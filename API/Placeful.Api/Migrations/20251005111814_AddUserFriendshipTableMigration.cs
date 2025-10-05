using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Placeful.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddUserFriendshipTableMigration : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddUniqueConstraint(
                name: "AK_UserProfiles_FirebaseUid",
                table: "UserProfiles",
                column: "FirebaseUid");

            migrationBuilder.CreateTable(
                name: "UserFriendships",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    FriendshipInitiatorId = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    FriendshipReceiverId = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    FriendshipAccepted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserFriendships", x => x.Id);
                    table.ForeignKey(
                        name: "FK_UserFriendships_UserProfiles_FriendshipInitiatorId",
                        column: x => x.FriendshipInitiatorId,
                        principalTable: "UserProfiles",
                        principalColumn: "FirebaseUid",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_UserFriendships_UserProfiles_FriendshipReceiverId",
                        column: x => x.FriendshipReceiverId,
                        principalTable: "UserProfiles",
                        principalColumn: "FirebaseUid",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_UserFriendships_FriendshipInitiatorId",
                table: "UserFriendships",
                column: "FriendshipInitiatorId");

            migrationBuilder.CreateIndex(
                name: "IX_UserFriendships_FriendshipReceiverId",
                table: "UserFriendships",
                column: "FriendshipReceiverId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "UserFriendships");

            migrationBuilder.DropUniqueConstraint(
                name: "AK_UserProfiles_FirebaseUid",
                table: "UserProfiles");
        }
    }
}
