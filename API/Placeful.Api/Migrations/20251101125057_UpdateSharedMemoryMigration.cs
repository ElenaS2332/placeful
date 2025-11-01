using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Placeful.Api.Migrations
{
    /// <inheritdoc />
    public partial class UpdateSharedMemoryMigration : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_SharedMemories_UserProfiles_SharedWithUserId",
                table: "SharedMemories");

            migrationBuilder.AddColumn<Guid>(
                name: "SharedFromUserId",
                table: "SharedMemories",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "UserProfileId",
                table: "SharedMemories",
                type: "uuid",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_SharedMemories_SharedFromUserId",
                table: "SharedMemories",
                column: "SharedFromUserId");

            migrationBuilder.CreateIndex(
                name: "IX_SharedMemories_UserProfileId",
                table: "SharedMemories",
                column: "UserProfileId");

            migrationBuilder.AddForeignKey(
                name: "FK_SharedMemories_UserProfiles_SharedFromUserId",
                table: "SharedMemories",
                column: "SharedFromUserId",
                principalTable: "UserProfiles",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_SharedMemories_UserProfiles_SharedWithUserId",
                table: "SharedMemories",
                column: "SharedWithUserId",
                principalTable: "UserProfiles",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_SharedMemories_UserProfiles_UserProfileId",
                table: "SharedMemories",
                column: "UserProfileId",
                principalTable: "UserProfiles",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_SharedMemories_UserProfiles_SharedFromUserId",
                table: "SharedMemories");

            migrationBuilder.DropForeignKey(
                name: "FK_SharedMemories_UserProfiles_SharedWithUserId",
                table: "SharedMemories");

            migrationBuilder.DropForeignKey(
                name: "FK_SharedMemories_UserProfiles_UserProfileId",
                table: "SharedMemories");

            migrationBuilder.DropIndex(
                name: "IX_SharedMemories_SharedFromUserId",
                table: "SharedMemories");

            migrationBuilder.DropIndex(
                name: "IX_SharedMemories_UserProfileId",
                table: "SharedMemories");

            migrationBuilder.DropColumn(
                name: "SharedFromUserId",
                table: "SharedMemories");

            migrationBuilder.DropColumn(
                name: "UserProfileId",
                table: "SharedMemories");

            migrationBuilder.AddForeignKey(
                name: "FK_SharedMemories_UserProfiles_SharedWithUserId",
                table: "SharedMemories",
                column: "SharedWithUserId",
                principalTable: "UserProfiles",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
