using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Placeful.Api.Migrations
{
    /// <inheritdoc />
    public partial class ModifyFavoriteMemoriesListTableMigration : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_FavoriteMemoriesLists_Memories_MemoryId",
                table: "FavoriteMemoriesLists");

            migrationBuilder.DropForeignKey(
                name: "FK_FavoriteMemoriesLists_UserProfiles_UserProfileId",
                table: "FavoriteMemoriesLists");

            migrationBuilder.DropIndex(
                name: "IX_FavoriteMemoriesLists_MemoryId",
                table: "FavoriteMemoriesLists");

            migrationBuilder.DropIndex(
                name: "IX_FavoriteMemoriesLists_UserProfileId",
                table: "FavoriteMemoriesLists");

            migrationBuilder.DropColumn(
                name: "MemoryId",
                table: "FavoriteMemoriesLists");

            migrationBuilder.AddColumn<Guid>(
                name: "FavoritesMemoriesListId",
                table: "UserProfiles",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "FavoriteMemoriesListId",
                table: "Memories",
                type: "uuid",
                nullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "UserProfileId",
                table: "FavoriteMemoriesLists",
                type: "character varying(1000)",
                maxLength: 1000,
                nullable: false,
                oldClrType: typeof(Guid),
                oldType: "uuid");

            migrationBuilder.CreateIndex(
                name: "IX_UserProfiles_FavoritesMemoriesListId",
                table: "UserProfiles",
                column: "FavoritesMemoriesListId");

            migrationBuilder.CreateIndex(
                name: "IX_Memories_FavoriteMemoriesListId",
                table: "Memories",
                column: "FavoriteMemoriesListId");

            migrationBuilder.AddForeignKey(
                name: "FK_Memories_FavoriteMemoriesLists_FavoriteMemoriesListId",
                table: "Memories",
                column: "FavoriteMemoriesListId",
                principalTable: "FavoriteMemoriesLists",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_UserProfiles_FavoriteMemoriesLists_FavoritesMemoriesListId",
                table: "UserProfiles",
                column: "FavoritesMemoriesListId",
                principalTable: "FavoriteMemoriesLists",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Memories_FavoriteMemoriesLists_FavoriteMemoriesListId",
                table: "Memories");

            migrationBuilder.DropForeignKey(
                name: "FK_UserProfiles_FavoriteMemoriesLists_FavoritesMemoriesListId",
                table: "UserProfiles");

            migrationBuilder.DropIndex(
                name: "IX_UserProfiles_FavoritesMemoriesListId",
                table: "UserProfiles");

            migrationBuilder.DropIndex(
                name: "IX_Memories_FavoriteMemoriesListId",
                table: "Memories");

            migrationBuilder.DropColumn(
                name: "FavoritesMemoriesListId",
                table: "UserProfiles");

            migrationBuilder.DropColumn(
                name: "FavoriteMemoriesListId",
                table: "Memories");

            migrationBuilder.AlterColumn<Guid>(
                name: "UserProfileId",
                table: "FavoriteMemoriesLists",
                type: "uuid",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(1000)",
                oldMaxLength: 1000);

            migrationBuilder.AddColumn<Guid>(
                name: "MemoryId",
                table: "FavoriteMemoriesLists",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.CreateIndex(
                name: "IX_FavoriteMemoriesLists_MemoryId",
                table: "FavoriteMemoriesLists",
                column: "MemoryId");

            migrationBuilder.CreateIndex(
                name: "IX_FavoriteMemoriesLists_UserProfileId",
                table: "FavoriteMemoriesLists",
                column: "UserProfileId",
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "FK_FavoriteMemoriesLists_Memories_MemoryId",
                table: "FavoriteMemoriesLists",
                column: "MemoryId",
                principalTable: "Memories",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_FavoriteMemoriesLists_UserProfiles_UserProfileId",
                table: "FavoriteMemoriesLists",
                column: "UserProfileId",
                principalTable: "UserProfiles",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
