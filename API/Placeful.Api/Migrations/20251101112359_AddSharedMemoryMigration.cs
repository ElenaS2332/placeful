using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Placeful.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddSharedMemoryMigration : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Memories_Locations_LocationId",
                table: "Memories");

            migrationBuilder.CreateTable(
                name: "SharedMemories",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    MemoryId = table.Column<Guid>(type: "uuid", nullable: false),
                    SharedWithUserId = table.Column<Guid>(type: "uuid", nullable: false),
                    SharedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_SharedMemories", x => x.Id);
                    table.ForeignKey(
                        name: "FK_SharedMemories_Memories_MemoryId",
                        column: x => x.MemoryId,
                        principalTable: "Memories",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_SharedMemories_UserProfiles_SharedWithUserId",
                        column: x => x.SharedWithUserId,
                        principalTable: "UserProfiles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_SharedMemories_MemoryId",
                table: "SharedMemories",
                column: "MemoryId");

            migrationBuilder.CreateIndex(
                name: "IX_SharedMemories_SharedWithUserId",
                table: "SharedMemories",
                column: "SharedWithUserId");

            migrationBuilder.AddForeignKey(
                name: "FK_Memories_Locations_LocationId",
                table: "Memories",
                column: "LocationId",
                principalTable: "Locations",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Memories_Locations_LocationId",
                table: "Memories");

            migrationBuilder.DropTable(
                name: "SharedMemories");

            migrationBuilder.AddForeignKey(
                name: "FK_Memories_Locations_LocationId",
                table: "Memories",
                column: "LocationId",
                principalTable: "Locations",
                principalColumn: "Id");
        }
    }
}
