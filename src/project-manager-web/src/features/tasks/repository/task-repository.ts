import { apiClient } from "@/core/api/client";
import { ApiEndpoints } from "@/core/api/constants";
import { ApiException } from "@/core/api/exceptions";
import type { TaskItem, TaskDetail, CreateTaskRequest, UpdateTaskRequest } from "../models/types";
import type { PaginatedResponse } from "@/core/api/types";
import { AxiosError } from "axios";

function handleError(error: unknown): never {
  if (error instanceof AxiosError) {
    throw ApiException.fromResponse(error.response?.status ?? 500, error.response?.data);
  }
  throw error;
}

export const taskRepository = {
  async list(projectId?: string): Promise<TaskItem[]> {
    try {
      const response = await apiClient.get<PaginatedResponse<TaskItem>>(ApiEndpoints.tasks, {
        params: { ...(projectId ? { projectId } : {}), pageSize: 100 },
      });
      return response.data.items;
    } catch (error) { handleError(error); }
  },

  async get(id: string): Promise<TaskDetail> {
    try {
      const response = await apiClient.get<TaskDetail>(ApiEndpoints.taskById(id));
      return response.data;
    } catch (error) { handleError(error); }
  },

  async create(request: CreateTaskRequest): Promise<void> {
    try {
      await apiClient.post(ApiEndpoints.tasks, request);
    } catch (error) { handleError(error); }
  },

  async update(id: string, request: UpdateTaskRequest): Promise<void> {
    try {
      await apiClient.put(ApiEndpoints.taskById(id), request);
    } catch (error) { handleError(error); }
  },

  async delete(id: string): Promise<void> {
    try {
      await apiClient.delete(ApiEndpoints.taskById(id));
    } catch (error) { handleError(error); }
  },
};
