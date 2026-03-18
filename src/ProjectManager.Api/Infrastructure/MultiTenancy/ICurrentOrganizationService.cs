namespace ProjectManager.Api.Infrastructure.MultiTenancy;

public interface ICurrentOrganizationService
{
    Guid? OrganizationId { get; }
    void SetOrganizationId(Guid organizationId);
}

public class CurrentOrganizationService : ICurrentOrganizationService
{
    public Guid? OrganizationId { get; private set; }

    public void SetOrganizationId(Guid organizationId)
    {
        OrganizationId = organizationId;
    }
}
