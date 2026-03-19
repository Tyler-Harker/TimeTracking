export type ProjectStatus = "Planned" | "Active" | "OnHold" | "Completed" | "Cancelled";

export interface Project {
  id: string;
  name: string;
  status: ProjectStatus;
  clientId: string;
  clientName: string;
  budgetAmount?: number;
}

export interface ProjectDetail extends Project {
  description?: string;
  defaultBillableRate?: number;
  startDate?: string;
  endDate?: string;
  createdAt: string;
  updatedAt: string;
}

export interface CreateProjectRequest {
  name: string;
  clientId: string;
  status?: ProjectStatus;
  budgetAmount?: number;
  defaultBillableRate?: number;
  startDate?: string;
  endDate?: string;
}

export interface UpdateProjectRequest {
  name?: string;
  status?: ProjectStatus;
  budgetAmount?: number;
  defaultBillableRate?: number;
  startDate?: string;
  endDate?: string;
}
