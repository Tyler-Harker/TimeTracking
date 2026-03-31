import { apiClient } from "@/core/api/client";
import { ApiEndpoints } from "@/core/api/constants";
import { ApiException } from "@/core/api/exceptions";
import type { Invoice, InvoiceDetail, GenerateInvoiceRequest, UpdateInvoiceStatusRequest, AddLineItemRequest } from "../models/types";
import type { PaginatedResponse } from "@/core/api/types";
import { AxiosError } from "axios";

function handleError(error: unknown): never {
  if (error instanceof AxiosError) {
    throw ApiException.fromResponse(error.response?.status ?? 500, error.response?.data);
  }
  throw error;
}

export const invoiceRepository = {
  async list(): Promise<Invoice[]> {
    try {
      const response = await apiClient.get<PaginatedResponse<Invoice>>(ApiEndpoints.invoices, {
        params: { pageSize: 100 },
      });
      return response.data.items;
    } catch (error) { handleError(error); }
  },

  async get(id: string): Promise<InvoiceDetail> {
    try {
      const response = await apiClient.get<InvoiceDetail>(ApiEndpoints.invoiceById(id));
      return response.data;
    } catch (error) { handleError(error); }
  },

  async generate(request: GenerateInvoiceRequest): Promise<void> {
    try {
      await apiClient.post(ApiEndpoints.generateInvoice, request);
    } catch (error) { handleError(error); }
  },

  async updateStatus(id: string, request: UpdateInvoiceStatusRequest): Promise<void> {
    try {
      await apiClient.patch(ApiEndpoints.invoiceStatus(id), request);
    } catch (error) { handleError(error); }
  },

  async addLineItem(invoiceId: string, request: AddLineItemRequest): Promise<void> {
    try {
      await apiClient.post(ApiEndpoints.invoiceLineItems(invoiceId), request);
    } catch (error) { handleError(error); }
  },
};
