import { AxiosError } from "axios";
import { apiClient } from "@/core/api/client";
import { ApiEndpoints } from "@/core/api/constants";
import { ApiException } from "@/core/api/exceptions";
import type { SyncImportSummary } from "../models/types";

function handleError(error: unknown): never {
  if (error instanceof AxiosError) {
    throw ApiException.fromResponse(error.response?.status ?? 500, error.response?.data);
  }
  throw error;
}

export const syncRepository = {
  async export(): Promise<{ blob: Blob; filename: string }> {
    try {
      const response = await apiClient.get<Blob>(ApiEndpoints.syncExport, {
        responseType: "blob",
      });
      const disposition = response.headers["content-disposition"] as string | undefined;
      const match = disposition?.match(/filename="?([^"]+)"?/);
      const filename = match?.[1] ?? `projectmanager-export-${Date.now()}.json`;
      return { blob: response.data, filename };
    } catch (error) {
      handleError(error);
    }
  },

  async import(payload: unknown): Promise<SyncImportSummary> {
    try {
      const response = await apiClient.post<SyncImportSummary>(
        ApiEndpoints.syncImport,
        payload,
      );
      return response.data;
    } catch (error) {
      handleError(error);
    }
  },
};
