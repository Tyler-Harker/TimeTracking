export interface Team {
  id: string;
  name: string;
  description?: string;
  memberCount: number;
}

export interface TeamDetail extends Team {
  projectId: string;
  projectName: string;
  createdAt: string;
  members: TeamMember[];
}

export interface TeamMember {
  userId: string;
  userName: string;
  joinedAt: string;
}

export interface CreateTeamRequest {
  projectId: string;
  name: string;
  description?: string;
}

export interface AddTeamMemberRequest {
  userId: string;
}
