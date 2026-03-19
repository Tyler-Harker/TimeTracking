import { apiClient } from "@/core/api/client";
import { ApiEndpoints } from "@/core/api/constants";
import { ApiException } from "@/core/api/exceptions";
import type { Organization, OrganizationDetail, CreateOrganizationRequest, UpdateOrganizationRequest } from "../models/types";
import { AxiosError } from "axios";

function handleError(error: unknown): never {
  if (error instanceof AxiosError) {
    throw ApiException.fromResponse(error.response?.status ?? 500, error.response?.data);
  }
  throw error;
}

export const organizationRepository = {
  async list(): Promise<Organization[]> {
    try {
      const response = await apiClient.get<Organization[]>(ApiEndpoints.organizations);
      return response.data;
    } catch (error) { handleError(error); }
  },

  async get(id: string): Promise<OrganizationDetail> {
    try {
      const response = await apiClient.get<OrganizationDetail>(ApiEndpoints.organizationById(id));
      return response.data;
    } catch (error) { handleError(error); }
  },

  async create(request: CreateOrganizationRequest): Promise<void> {
    try {
      await apiClient.post(ApiEndpoints.organizations, request);
    } catch (error) { handleError(error); }
  },

  async update(id: string, request: UpdateOrganizationRequest): Promise<void> {
    try {
      await apiClient.put(ApiEndpoints.organizationById(id), request);
    } catch (error) { handleError(error); }
  },

  async delete(id: string): Promise<void> {
    try {
      await apiClient.delete(ApiEndpoints.organizationById(id));
    } catch (error) { handleError(error); }
  },
};
