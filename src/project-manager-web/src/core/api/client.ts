import axios, {
  AxiosError,
  type AxiosInstance,
  type InternalAxiosRequestConfig,
} from "axios";
import { API_BASE_URL, ApiEndpoints } from "./constants";
import { tokenStorage, orgStorage } from "../auth/token-storage";
import { useAuthStore } from "@/features/auth/store/auth-store";

const EXCLUDED_AUTH_PATHS = ["/api/auth/"];
const EXCLUDED_ORG_PATHS = ["/api/auth/", "/api/organizations", "/api/users/me"];

let isRefreshing = false;
let refreshPromise: Promise<string | null> | null = null;

function shouldSkipAuth(url?: string): boolean {
  return EXCLUDED_AUTH_PATHS.some((p) => url?.includes(p));
}

function shouldSkipOrg(url?: string): boolean {
  return EXCLUDED_ORG_PATHS.some((p) => {
    if (p === "/api/organizations") {
      return url === "/api/organizations" || url === p;
    }
    return url?.includes(p);
  });
}

async function refreshTokens(): Promise<string | null> {
  if (isRefreshing && refreshPromise) {
    return refreshPromise;
  }

  isRefreshing = true;
  refreshPromise = (async () => {
    try {
      const token = tokenStorage.getAccessToken();
      const refreshToken = tokenStorage.getRefreshToken();
      if (!token || !refreshToken) return null;

      const response = await axios.post(
        `${API_BASE_URL}${ApiEndpoints.refreshToken}`,
        { token, refreshToken }
      );

      const { token: newToken, refreshToken: newRefresh, expiresAt } = response.data;
      tokenStorage.saveTokens(newToken, newRefresh, expiresAt);
      return newToken;
    } catch {
      return null;
    } finally {
      isRefreshing = false;
      refreshPromise = null;
    }
  })();

  return refreshPromise;
}

export function createApiClient(): AxiosInstance {
  const client = axios.create({
    baseURL: API_BASE_URL,
    timeout: 15000,
    headers: {
      "Content-Type": "application/json",
      Accept: "application/json",
    },
  });

  // Auth interceptor
  client.interceptors.request.use((config: InternalAxiosRequestConfig) => {
    if (!shouldSkipAuth(config.url)) {
      const token = tokenStorage.getAccessToken();
      if (token) {
        config.headers.Authorization = `Bearer ${token}`;
      }
    }
    return config;
  });

  // Organization interceptor
  client.interceptors.request.use((config: InternalAxiosRequestConfig) => {
    if (!shouldSkipOrg(config.url)) {
      const orgId = orgStorage.getActiveOrganizationId();
      if (orgId) {
        config.headers["X-Organization-Id"] = orgId;
      }
    }
    return config;
  });

  // Token refresh interceptor
  client.interceptors.response.use(
    (response) => response,
    async (error: AxiosError) => {
      const originalRequest = error.config;
      if (
        error.response?.status === 401 &&
        originalRequest &&
        !shouldSkipAuth(originalRequest.url) &&
        !(originalRequest as unknown as Record<string, unknown>)._retry
      ) {
        (originalRequest as unknown as Record<string, unknown>)._retry = true;
        const newToken = await refreshTokens();
        if (newToken) {
          originalRequest.headers.Authorization = `Bearer ${newToken}`;
          return client(originalRequest);
        }

        // Refresh failed — log out
        useAuthStore.getState().logout();
      }
      return Promise.reject(error);
    }
  );

  return client;
}

export const apiClient = createApiClient();
