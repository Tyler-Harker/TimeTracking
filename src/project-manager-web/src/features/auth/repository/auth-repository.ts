import { apiClient } from "@/core/api/client";
import { ApiEndpoints } from "@/core/api/constants";
import { ApiException } from "@/core/api/exceptions";
import type { RegisterRequest, RegisterResponse } from "../models/types";
import { AxiosError } from "axios";

export const authRepository = {
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
