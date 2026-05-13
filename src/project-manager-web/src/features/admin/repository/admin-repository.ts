import axios, { AxiosError, type AxiosInstance, type InternalAxiosRequestConfig } from "axios";
import { API_BASE_URL } from "@/core/api/constants";
import { ApiException } from "@/core/api/exceptions";
import { adminTokenStorage } from "../storage/admin-token-storage";

export interface AdminLoginRequest {
  username: string;
  password: string;
}

export interface AdminLoginResponse {
  token: string;
  expiresAt: string;
}

export interface AdminUser {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
}

export interface ListUsersResponse {
  items: AdminUser[];
  total: number;
  page: number;
  pageSize: number;
}

export interface ListUsersParams {
  search?: string;
  page?: number;
  pageSize?: number;
}

function createClient(): AxiosInstance {
  const client = axios.create({
    baseURL: API_BASE_URL,
    timeout: 15000,
    headers: {
      "Content-Type": "application/json",
      Accept: "application/json",
    },
  });

  client.interceptors.request.use((config: InternalAxiosRequestConfig) => {
    const token = adminTokenStorage.getToken();
    if (token && !config.url?.includes("/api/admin/login")) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  });

  return client;
}

const adminClient = createClient();

function wrap<T>(promise: Promise<{ data: T }>): Promise<T> {
  return promise
    .then((res) => res.data)
    .catch((error) => {
      if (error instanceof AxiosError) {
        throw ApiException.fromResponse(error.response?.status ?? 500, error.response?.data);
      }
      throw error;
    });
}

export const adminRepository = {
  login(request: AdminLoginRequest): Promise<AdminLoginResponse> {
    return wrap(adminClient.post<AdminLoginResponse>("/api/admin/login", request));
  },

  listUsers(params: ListUsersParams = {}): Promise<ListUsersResponse> {
    return wrap(adminClient.get<ListUsersResponse>("/api/admin/users", { params }));
  },

  resetPassword(userId: string, newPassword: string): Promise<{ userId: string; email: string }> {
    return wrap(adminClient.post(`/api/admin/users/${userId}/password`, { newPassword }));
  },

  setActive(userId: string, isActive: boolean): Promise<AdminUser> {
    return wrap(adminClient.post(`/api/admin/users/${userId}/active`, { isActive }));
  },
};
