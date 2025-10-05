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
        
        CreateMap<MemoryDto, Memory>()
            .ForMember(dest => dest.Id, opt => opt.Ignore());
        CreateMap<Memory, MemoryDto>();
        
        CreateMap<UserFriendship, UserFriendshipDto>()
            .ForMember(dest => dest.FriendshipInitiator, opt => opt.MapFrom(src => src.FriendshipInitiator))
            .ForMember(dest => dest.FriendshipReceiver, opt => opt.MapFrom(src => src.FriendshipReceiver))
            .ForMember(dest => dest.FriendshipAccepted, opt => opt.MapFrom(src => src.FriendshipAccepted));

        CreateMap<UserFriendshipDto, UserFriendship>()
            .ForMember(dest => dest.Id, opt => opt.Ignore())
            .ForMember(dest => dest.FriendshipInitiator, opt => opt.Ignore())
            .ForMember(dest => dest.FriendshipReceiver, opt => opt.Ignore()) 
            .ForMember(dest => dest.FriendshipAccepted, opt => opt.MapFrom(src => src.FriendshipAccepted));
    }
}