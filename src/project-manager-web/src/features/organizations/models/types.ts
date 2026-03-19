export interface Organization {
  id: string;
  name: string;
  slug: string;
  description?: string;
  role?: string;
  defaultBillableRate?: number;
}

export interface OrganizationDetail extends Organization {
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
  memberCount: number;
}

export interface CreateOrganizationRequest {
  name: string;
  slug: string;
  description?: string;
  defaultBillableRate?: number;
}

export interface UpdateOrganizationRequest {
  name?: string;
  description?: string;
  defaultBillableRate?: number;
}
