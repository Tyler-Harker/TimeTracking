export interface TimeEntry {
  id: string;
  userId: string;
  userName: string;
  projectId: string;
  projectName: string;
  date: string;
  hours: number;
  description?: string;
  billableRate?: number | null;
  inheritedBillableRate?: number | null;
  isBillable: boolean;
  isInvoiced: boolean;
  taskId?: string;
  taskName?: string;
}

export interface CreateTimeEntryRequest {
  projectId: string;
  date: string;
  hours: number;
  description?: string;
  isBillable?: boolean;
  taskId?: string;
}

export interface UpdateTimeEntryRequest {
  date?: string;
  hours?: number;
  description?: string;
  billableRate?: number | null;
  isBillable?: boolean;
  taskId?: string | null;
}
