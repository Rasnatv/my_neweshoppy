
class LocationItem {
  String location;
  LocationItem({required this.location});
}

class DistrictItem {
  String district;
  List<LocationItem> locations;

  DistrictItem({
    required this.district,
    required this.locations,
  });
}

class StateItem {
  String state;
  List<DistrictItem> districts;

  StateItem({
    required this.state,
    required this.districts,
  });
}
