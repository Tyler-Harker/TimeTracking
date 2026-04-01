export interface Organization {
  id: string;
  name: string;
  slug: string;
  description?: string;
  role?: string;
  address?: string;
  phone?: string;
  email?: string;
  defaultBillableRate?: number;
  bankAccountNumber?: string;
  bankRoutingNumber?: string;
}

export interface OrganizationDetail extends Organization {
  isActive: boolean;
  createdAt: string;
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
  address?: string;
  phone?: string;
  email?: string;
  defaultBillableRate?: number;
  bankAccountNumber?: string;
  bankRoutingNumber?: string;
}
