namespace Placeful.Api.Services.Interface;

public interface IBlobStorageService
{
    public Task<string> UploadFileAsync(IFormFile file);
}