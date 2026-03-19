import { apiClient } from "@/core/api/client";
import { ApiEndpoints } from "@/core/api/constants";
import { ApiException } from "@/core/api/exceptions";
import type { LoginRequest, LoginResponse, RegisterRequest, RegisterResponse } from "../models/types";
import { AxiosError } from "axios";

export const authRepository = {
  async login(request: LoginRequest): Promise<LoginResponse> {
    try {
      const response = await apiClient.post<LoginResponse>(ApiEndpoints.login, request);
      return response.data;
    } catch (error) {
      if (error instanceof AxiosError) {
        throw ApiException.fromResponse(error.response?.status ?? 500, error.response?.data);
      }
      throw error;
    }
  },

  async register(request: RegisterRequest): Promise<RegisterResponse> {
    try {
      const response = await apiClient.post<RegisterResponse>(ApiEndpoints.register, request);
      return response.data;
    } catch (error) {
      if (error instanceof AxiosError) {
        throw ApiException.fromResponse(error.response?.status ?? 500, error.response?.data);
      }
      throw error;
    }
  },
};
