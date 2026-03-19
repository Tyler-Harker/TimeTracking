import { apiClient } from "@/core/api/client";
import { ApiEndpoints } from "@/core/api/constants";
import { ApiException } from "@/core/api/exceptions";
import type { Team, TeamDetail, CreateTeamRequest, AddTeamMemberRequest } from "../models/types";
import { AxiosError } from "axios";

function handleError(error: unknown): never {
  if (error instanceof AxiosError) {
    throw ApiException.fromResponse(error.response?.status ?? 500, error.response?.data);
  }
  throw error;
}

export const teamRepository = {
  async list(projectId?: string): Promise<Team[]> {
    try {
      const response = await apiClient.get<Team[]>(ApiEndpoints.teams, {
        params: projectId ? { projectId } : undefined,
      });
      return response.data;
    } catch (error) { handleError(error); }
  },

  async get(id: string): Promise<TeamDetail> {
    try {
      const response = await apiClient.get<TeamDetail>(ApiEndpoints.teamById(id));
      return response.data;
    } catch (error) { handleError(error); }
  },

  async create(request: CreateTeamRequest): Promise<void> {
    try {
      await apiClient.post(ApiEndpoints.teams, request);
    } catch (error) { handleError(error); }
  },

  async addMember(teamId: string, request: AddTeamMemberRequest): Promise<void> {
    try {
      await apiClient.post(ApiEndpoints.teamMembers(teamId), request);
    } catch (error) { handleError(error); }
  },

  async removeMember(teamId: string, userId: string): Promise<void> {
    try {
      await apiClient.delete(ApiEndpoints.teamMember(teamId, userId));
    } catch (error) { handleError(error); }
  },
};
