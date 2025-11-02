using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Placeful.Api.Migrations
{
    /// <inheritdoc />
    public partial class MakeFriendsListTransientMigration : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Memories_Locations_LocationId",
                table: "Memories");

            migrationBuilder.DropForeignKey(
                name: "FK_SharedMemories_UserProfiles_SharedFromUserId",
                table: "SharedMemories");

            migrationBuilder.DropForeignKey(
                name: "FK_SharedMemories_UserProfiles_SharedWithUserId",
                table: "SharedMemories");

            migrationBuilder.DropForeignKey(
                name: "FK_UserFriendships_UserProfiles_FriendshipInitiatorId",
                table: "UserFriendships");

            migrationBuilder.DropForeignKey(
                name: "FK_UserFriendships_UserProfiles_FriendshipReceiverId",
                table: "UserFriendships");

            migrationBuilder.DropForeignKey(
                name: "FK_UserProfiles_UserProfiles_UserProfileId",
                table: "UserProfiles");

            migrationBuilder.DropIndex(
                name: "IX_UserProfiles_UserProfileId",
                table: "UserProfiles");

            migrationBuilder.DropColumn(
                name: "UserProfileId",
                table: "UserProfiles");

            migrationBuilder.AddForeignKey(
                name: "FK_Memories_Locations_LocationId",
                table: "Memories",
                column: "LocationId",
                principalTable: "Locations",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_SharedMemories_UserProfiles_SharedFromUserId",
                table: "SharedMemories",
                column: "SharedFromUserId",
                principalTable: "UserProfiles",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_SharedMemories_UserProfiles_SharedWithUserId",
                table: "SharedMemories",
                column: "SharedWithUserId",
                principalTable: "UserProfiles",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_UserFriendships_UserProfiles_FriendshipInitiatorId",
                table: "UserFriendships",
                column: "FriendshipInitiatorId",
                principalTable: "UserProfiles",
                principalColumn: "FirebaseUid",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_UserFriendships_UserProfiles_FriendshipReceiverId",
                table: "UserFriendships",
                column: "FriendshipReceiverId",
                principalTable: "UserProfiles",
                principalColumn: "FirebaseUid",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Memories_Locations_LocationId",
                table: "Memories");

            migrationBuilder.DropForeignKey(
                name: "FK_SharedMemories_UserProfiles_SharedFromUserId",
                table: "SharedMemories");

            migrationBuilder.DropForeignKey(
                name: "FK_SharedMemories_UserProfiles_SharedWithUserId",
                table: "SharedMemories");

            migrationBuilder.DropForeignKey(
                name: "FK_UserFriendships_UserProfiles_FriendshipInitiatorId",
                table: "UserFriendships");

            migrationBuilder.DropForeignKey(
                name: "FK_UserFriendships_UserProfiles_FriendshipReceiverId",
                table: "UserFriendships");

            migrationBuilder.AddColumn<Guid>(
                name: "UserProfileId",
                table: "UserProfiles",
                type: "uuid",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_UserProfiles_UserProfileId",
                table: "UserProfiles",
                column: "UserProfileId");

            migrationBuilder.AddForeignKey(
                name: "FK_Memories_Locations_LocationId",
                table: "Memories",
                column: "LocationId",
                principalTable: "Locations",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

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
                name: "FK_UserFriendships_UserProfiles_FriendshipInitiatorId",
                table: "UserFriendships",
                column: "FriendshipInitiatorId",
                principalTable: "UserProfiles",
                principalColumn: "FirebaseUid",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_UserFriendships_UserProfiles_FriendshipReceiverId",
                table: "UserFriendships",
                column: "FriendshipReceiverId",
                principalTable: "UserProfiles",
                principalColumn: "FirebaseUid",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_UserProfiles_UserProfiles_UserProfileId",
                table: "UserProfiles",
                column: "UserProfileId",
                principalTable: "UserProfiles",
                principalColumn: "Id");
        }
    }
}
