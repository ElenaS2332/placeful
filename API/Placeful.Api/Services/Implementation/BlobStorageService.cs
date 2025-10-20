using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using Placeful.Api.Services.Interface;

namespace Placeful.Api.Services.Implementation;

public class BlobStorageService : IBlobStorageService
{
    private readonly BlobContainerClient _containerClient;

    public BlobStorageService(IConfiguration config)
    {
        var connectionString = config["AzureBlob:ConnectionString"];
        var containerName = config["AzureBlob:ContainerName"];
        _containerClient = new BlobContainerClient(connectionString, containerName);
        _containerClient.CreateIfNotExists(PublicAccessType.Blob);
    }

    public async Task<string> UploadFileAsync(IFormFile file)
    {
        var fileName = $"{Guid.NewGuid()}_{file.FileName}";
        var blobClient = _containerClient.GetBlobClient(fileName);

        await using var stream = file.OpenReadStream();
        await blobClient.UploadAsync(stream, new BlobHttpHeaders { ContentType = file.ContentType });

        return blobClient.Uri.ToString();
    }

    public async Task DeleteFileAsync(string blobUrl)
    {
        var uri = new Uri(blobUrl);
        var blobName = uri.Segments.Last();
        var containerName = uri.Segments[1].TrimEnd('/');

        var blobClient = _containerClient.GetBlobClient(blobName);

        await blobClient.DeleteIfExistsAsync();
    }
}
