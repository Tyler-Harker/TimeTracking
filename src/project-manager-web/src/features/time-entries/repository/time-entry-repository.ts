import { apiClient } from "@/core/api/client";
import { ApiEndpoints } from "@/core/api/constants";
import { ApiException } from "@/core/api/exceptions";
import type { TimeEntry, CreateTimeEntryRequest, UpdateTimeEntryRequest } from "../models/types";
import type { PaginatedResponse } from "@/core/api/types";
import { AxiosError } from "axios";

function handleError(error: unknown): never {
  if (error instanceof AxiosError) {
    throw ApiException.fromResponse(error.response?.status ?? 500, error.response?.data);
  }
  throw error;
}

export const timeEntryRepository = {
  async list(filters?: { projectId?: string; taskId?: string }): Promise<TimeEntry[]> {
    try {
      const response = await apiClient.get<PaginatedResponse<TimeEntry>>(ApiEndpoints.timeEntries, {
        params: { ...filters, pageSize: 100 },
      });
      return response.data.items;
    } catch (error) { handleError(error); }
  },

  async get(id: string): Promise<TimeEntry> {
    try {
      const response = await apiClient.get<TimeEntry>(ApiEndpoints.timeEntryById(id));
      return response.data;
    } catch (error) { handleError(error); }
  },

  async create(request: CreateTimeEntryRequest): Promise<void> {
    try {
      await apiClient.post(ApiEndpoints.timeEntries, request);
    } catch (error) { handleError(error); }
  },

  async update(id: string, request: UpdateTimeEntryRequest): Promise<void> {
    try {
      await apiClient.put(ApiEndpoints.timeEntryById(id), request);
    } catch (error) { handleError(error); }
  },

  async delete(id: string): Promise<void> {
    try {
      await apiClient.delete(ApiEndpoints.timeEntryById(id));
    } catch (error) { handleError(error); }
  },
};
