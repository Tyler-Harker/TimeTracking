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

export interface TimeEntryListFilters {
  projectId?: string;
  taskId?: string;
  userId?: string;
  clientId?: string;
  fromDate?: string;
  toDate?: string;
  unpaged?: boolean;
  pageSize?: number;
}

export const timeEntryRepository = {
  async list(filters?: TimeEntryListFilters): Promise<TimeEntry[]> {
    try {
      const { unpaged, pageSize, ...rest } = filters ?? {};
      const params: Record<string, unknown> = { ...rest };
      if (unpaged) {
        params.unpaged = true;
      } else {
        params.pageSize = pageSize ?? 100;
      }
      const response = await apiClient.get<PaginatedResponse<TimeEntry>>(ApiEndpoints.timeEntries, { params });
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
