using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using ProjectManager.Api.Data.Entities;

namespace ProjectManager.Api.Data.Configurations;

public class ClientContactConfiguration : IEntityTypeConfiguration<ClientContact>
{
    public void Configure(EntityTypeBuilder<ClientContact> builder)
    {
        builder.HasKey(cc => cc.Id);
        builder.Property(cc => cc.Name).IsRequired().HasMaxLength(200);
        builder.Property(cc => cc.Email).HasMaxLength(200);
        builder.Property(cc => cc.Phone).HasMaxLength(50);
        builder.HasOne(cc => cc.Client)
            .WithMany(c => c.Contacts)
            .HasForeignKey(cc => cc.ClientId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
