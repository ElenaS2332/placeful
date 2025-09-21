using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Placeful.Api.Migrations
{
    /// <inheritdoc />
    public partial class ChangeTableNameMigration : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_FavoritesLists_Memories_MemoryId",
                table: "FavoritesLists");

            migrationBuilder.DropForeignKey(
                name: "FK_FavoritesLists_UserProfiles_UserProfileId",
                table: "FavoritesLists");

            migrationBuilder.DropPrimaryKey(
                name: "PK_FavoritesLists",
                table: "FavoritesLists");

            migrationBuilder.RenameTable(
                name: "FavoritesLists",
                newName: "FavoriteMemoriesLists");

            migrationBuilder.RenameIndex(
                name: "IX_FavoritesLists_UserProfileId",
                table: "FavoriteMemoriesLists",
                newName: "IX_FavoriteMemoriesLists_UserProfileId");

            migrationBuilder.RenameIndex(
                name: "IX_FavoritesLists_MemoryId",
                table: "FavoriteMemoriesLists",
                newName: "IX_FavoriteMemoriesLists_MemoryId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_FavoriteMemoriesLists",
                table: "FavoriteMemoriesLists",
                column: "Id");

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

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_FavoriteMemoriesLists_Memories_MemoryId",
                table: "FavoriteMemoriesLists");

            migrationBuilder.DropForeignKey(
                name: "FK_FavoriteMemoriesLists_UserProfiles_UserProfileId",
                table: "FavoriteMemoriesLists");

            migrationBuilder.DropPrimaryKey(
                name: "PK_FavoriteMemoriesLists",
                table: "FavoriteMemoriesLists");

            migrationBuilder.RenameTable(
                name: "FavoriteMemoriesLists",
                newName: "FavoritesLists");

            migrationBuilder.RenameIndex(
                name: "IX_FavoriteMemoriesLists_UserProfileId",
                table: "FavoritesLists",
                newName: "IX_FavoritesLists_UserProfileId");

            migrationBuilder.RenameIndex(
                name: "IX_FavoriteMemoriesLists_MemoryId",
                table: "FavoritesLists",
                newName: "IX_FavoritesLists_MemoryId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_FavoritesLists",
                table: "FavoritesLists",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_FavoritesLists_Memories_MemoryId",
                table: "FavoritesLists",
                column: "MemoryId",
                principalTable: "Memories",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_FavoritesLists_UserProfiles_UserProfileId",
                table: "FavoritesLists",
                column: "UserProfileId",
                principalTable: "UserProfiles",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
