export type TaskStatus = "Open" | "InProgress" | "Completed";
export type TaskPriority = "Low" | "Medium" | "High" | "Urgent";

export interface TaskItem {
  id: string;
  projectId: string;
  projectName: string;
  name: string;
  status: TaskStatus;
  priority: TaskPriority;
  assigneeId?: string;
  assigneeName?: string;
  dueDate?: string;
  estimatedHours?: number;
  lastActivity: string;
}

export interface TaskDetail extends TaskItem {
  description?: string;
  createdAt: string;
  updatedAt: string;
}

export interface CreateTaskRequest {
  projectId: string;
  name: string;
  status?: TaskStatus;
  priority?: TaskPriority;
  assigneeId?: string;
  dueDate?: string;
  estimatedHours?: number;
  description?: string;
}

export interface UpdateTaskRequest {
  name?: string;
  status?: TaskStatus;
  priority?: TaskPriority;
  assigneeId?: string;
  dueDate?: string;
  estimatedHours?: number;
  description?: string;
}
