import { apiClient } from "@/core/api/client";
import { ApiEndpoints } from "@/core/api/constants";
import { ApiException } from "@/core/api/exceptions";
import type { UserProfile, UpdateUserRequest } from "../models/types";
import { AxiosError } from "axios";

export const userRepository = {
  async getCurrentUser(): Promise<UserProfile> {
    try {
      const response = await apiClient.get<UserProfile>(ApiEndpoints.currentUser);
      return response.data;
    } catch (error) {
      if (error instanceof AxiosError) {
        throw ApiException.fromResponse(error.response?.status ?? 500, error.response?.data);
      }
      throw error;
    }
  },

  async updateUser(request: UpdateUserRequest): Promise<void> {
    try {
      await apiClient.put(ApiEndpoints.currentUser, request);
    } catch (error) {
      if (error instanceof AxiosError) {
        throw ApiException.fromResponse(error.response?.status ?? 500, error.response?.data);
      }
      throw error;
    }
  },
};
