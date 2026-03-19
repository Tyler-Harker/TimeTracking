import { apiClient } from "@/core/api/client";
import { ApiEndpoints } from "@/core/api/constants";
import { ApiException } from "@/core/api/exceptions";
import type { DashboardSummary } from "../models/types";
import { AxiosError } from "axios";

export const dashboardRepository = {
  async getSummary(): Promise<DashboardSummary> {
    try {
      const response = await apiClient.get<DashboardSummary>(ApiEndpoints.dashboardSummary);
      return response.data;
    } catch (error) {
      if (error instanceof AxiosError) {
        throw ApiException.fromResponse(error.response?.status ?? 500, error.response?.data);
      }
      throw error;
    }
  },
};
