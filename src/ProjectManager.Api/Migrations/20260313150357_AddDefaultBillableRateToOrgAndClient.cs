using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ProjectManager.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddDefaultBillableRateToOrgAndClient : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<decimal>(
                name: "DefaultBillableRate",
                table: "Organizations",
                type: "numeric(18,2)",
                precision: 18,
                scale: 2,
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "DefaultBillableRate",
                table: "Clients",
                type: "numeric(18,2)",
                precision: 18,
                scale: 2,
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "DefaultBillableRate",
                table: "Organizations");

            migrationBuilder.DropColumn(
                name: "DefaultBillableRate",
                table: "Clients");
        }
    }
}
