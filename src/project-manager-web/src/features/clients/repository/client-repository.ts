import { apiClient } from "@/core/api/client";
import { ApiEndpoints } from "@/core/api/constants";
import { ApiException } from "@/core/api/exceptions";
import type { Client, ClientDetail, ClientContact, CreateClientRequest, UpdateClientRequest, CreateContactRequest, UpdateContactRequest } from "../models/types";
import { AxiosError } from "axios";

function handleError(error: unknown): never {
  if (error instanceof AxiosError) {
    throw ApiException.fromResponse(error.response?.status ?? 500, error.response?.data);
  }
  throw error;
}

export const clientRepository = {
  async list(): Promise<Client[]> {
    try {
      const response = await apiClient.get<Client[]>(ApiEndpoints.clients);
      return response.data;
    } catch (error) { handleError(error); }
  },

  async get(id: string): Promise<ClientDetail> {
    try {
      const response = await apiClient.get<ClientDetail>(ApiEndpoints.clientById(id));
      return response.data;
    } catch (error) { handleError(error); }
  },

  async create(request: CreateClientRequest): Promise<void> {
    try {
      await apiClient.post(ApiEndpoints.clients, request);
    } catch (error) { handleError(error); }
  },

  async update(id: string, request: UpdateClientRequest): Promise<void> {
    try {
      await apiClient.put(ApiEndpoints.clientById(id), request);
    } catch (error) { handleError(error); }
  },

  async delete(id: string): Promise<void> {
    try {
      await apiClient.delete(ApiEndpoints.clientById(id));
    } catch (error) { handleError(error); }
  },

  async listContacts(clientId: string): Promise<ClientContact[]> {
    try {
      const response = await apiClient.get<ClientContact[]>(ApiEndpoints.clientContacts(clientId));
      return response.data;
    } catch (error) { handleError(error); }
  },

  async addContact(clientId: string, request: CreateContactRequest): Promise<void> {
    try {
      await apiClient.post(ApiEndpoints.clientContacts(clientId), request);
    } catch (error) { handleError(error); }
  },

  async updateContact(clientId: string, contactId: string, request: UpdateContactRequest): Promise<void> {
    try {
      await apiClient.put(ApiEndpoints.clientContactById(clientId, contactId), request);
    } catch (error) { handleError(error); }
  },

  async removeContact(clientId: string, contactId: string): Promise<void> {
    try {
      await apiClient.delete(ApiEndpoints.clientContactById(clientId, contactId));
    } catch (error) { handleError(error); }
  },
};
