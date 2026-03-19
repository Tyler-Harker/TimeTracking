import { apiClient } from "@/core/api/client";
import { ApiEndpoints } from "@/core/api/constants";
import { ApiException } from "@/core/api/exceptions";
import type { Project, ProjectDetail, CreateProjectRequest, UpdateProjectRequest } from "../models/types";
import { AxiosError } from "axios";

function handleError(error: unknown): never {
  if (error instanceof AxiosError) {
    throw ApiException.fromResponse(error.response?.status ?? 500, error.response?.data);
  }
  throw error;
}

export const projectRepository = {
  async list(clientId?: string): Promise<Project[]> {
    try {
      const response = await apiClient.get<Project[]>(ApiEndpoints.projects, {
        params: clientId ? { clientId } : undefined,
      });
      return response.data;
    } catch (error) { handleError(error); }
  },

  async get(id: string): Promise<ProjectDetail> {
    try {
      const response = await apiClient.get<ProjectDetail>(ApiEndpoints.projectById(id));
      return response.data;
    } catch (error) { handleError(error); }
  },

  async create(request: CreateProjectRequest): Promise<void> {
    try {
      await apiClient.post(ApiEndpoints.projects, request);
    } catch (error) { handleError(error); }
  },

  async update(id: string, request: UpdateProjectRequest): Promise<void> {
    try {
      await apiClient.put(ApiEndpoints.projectById(id), request);
    } catch (error) { handleError(error); }
  },

  async delete(id: string): Promise<void> {
    try {
      await apiClient.delete(ApiEndpoints.projectById(id));
    } catch (error) { handleError(error); }
  },
};
