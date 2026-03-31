export interface Client {
  id: string;
  name: string;
  contactCount: number;
  isActive: boolean;
  defaultBillableRate?: number;
}

export interface ClientDetail extends Client {
  address?: string;
  website?: string;
  createdAt: string;
  updatedAt: string;
}

export interface ClientContact {
  id: string;
  name: string;
  email?: string;
  phone?: string;
  isStakeHolder: boolean;
  isInvoicing: boolean;
  createdAt: string;
}

export interface CreateClientRequest {
  name: string;
  address?: string;
  website?: string;
  defaultBillableRate?: number;
}

export interface UpdateClientRequest {
  name?: string;
  address?: string;
  website?: string;
  defaultBillableRate?: number;
  isActive?: boolean;
}

export interface CreateContactRequest {
  name: string;
  email?: string;
  phone?: string;
  isStakeHolder: boolean;
  isInvoicing: boolean;
}

export interface UpdateContactRequest {
  name: string;
  email?: string;
  phone?: string;
  isStakeHolder: boolean;
  isInvoicing: boolean;
}
