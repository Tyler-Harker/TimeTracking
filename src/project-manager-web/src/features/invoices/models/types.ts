export type InvoiceStatus = "Draft" | "Sent" | "Paid" | "Overdue";

export interface Invoice {
  id: string;
  invoiceNumber: string;
  status: InvoiceStatus;
  totalAmount: number;
  issuedDate: string;
  dueDate: string;
}

export interface InvoiceDetail extends Invoice {
  organizationId: string;
  clientId: string;
  clientName: string;
  projectId?: string;
  projectName?: string;
  taxRate: number;
  taxAmount: number;
  paidDate?: string;
  lineItems: InvoiceLineItem[];
}

export interface InvoiceLineItem {
  id: string;
  description: string;
  quantity: number;
  unitPrice: number;
  amount: number;
}

export interface GenerateInvoiceRequest {
  clientId: string;
  projectId?: string;
}

export interface UpdateInvoiceStatusRequest {
  status: InvoiceStatus;
}

export interface AddLineItemRequest {
  description: string;
  quantity: number;
  unitPrice: number;
}
