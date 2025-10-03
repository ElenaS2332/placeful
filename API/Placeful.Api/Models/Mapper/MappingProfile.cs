using AutoMapper;
using Placeful.Api.Models.DTOs;
using Placeful.Api.Models.Entities;

namespace Placeful.Api.Models.Mapper;

public class MappingProfile : Profile
{
    public MappingProfile()
    {
        CreateMap<UserProfileDto, UserProfile>()
            .ForMember(dest => dest.Id, opt => opt.Ignore()) 
            .ForMember(dest => dest.Friends, opt => opt.Ignore()) 
            .ForMember(dest => dest.FavoritesMemoriesList, opt => opt.Ignore())
            .ForMember(dest => dest.BirthDate,
                opt => opt.MapFrom(src => DateTime.SpecifyKind(src.BirthDate, DateTimeKind.Utc)));

        CreateMap<UserProfile, UserProfileDto>();
    }
}