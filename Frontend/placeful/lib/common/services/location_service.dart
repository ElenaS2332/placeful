import 'package:placeful/common/domain/dtos/location_dto.dart';
import 'package:placeful/common/domain/models/location.dart';
import 'package:placeful/common/services/http_service.dart';
import 'package:placeful/common/services/service_locatior.dart';

class LocationService {
  LocationService();

  final HttpService _client = getIt<HttpService>();

  Future<List<Location>> getLocations() async {
    final List response = await _client.get("locations/");
    return response
        .map((c) => LocationDto.fromJson(c))
        .map((dto) => Location.fromDto(dto))
        .toList();
  }

  Future<Location> getLocation(String id) async {
    final Map<String, dynamic> response = await _client.get("locations/$id");
    return Location.fromDto(LocationDto.fromJson(response));
  }

  Future<void> createLocation(Location location) async {
    await _client.post("locations/", location.toJson());
  }

  Future<void> deleteLocation(String id) async {
    await _client.delete("locations/$id");
  }
}
