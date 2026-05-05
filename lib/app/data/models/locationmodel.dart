

class LocationItem {
  final String location;
  LocationItem({required this.location});
}

// ── District with its locations ───────────────────────
class DistrictItem {
  final String district;
  final List<LocationItem> locations;

  DistrictItem({
    required this.district,
    required this.locations,
  });

  /// Builds a [DistrictItem] from the API shape:
  /// { "district": "kannur", "main_locations": ["caltex", ...] }
  factory DistrictItem.fromJson(Map<String, dynamic> json) {
    final rawLocations = (json['main_locations'] as List<dynamic>? ?? []);
    return DistrictItem(
      district: json['district']?.toString() ?? '',
      locations: rawLocations
          .toSet()
          .map((l) => LocationItem(location: l.toString()))
          .toList(),
    );
  }

  /// Merges another district's locations into this one (deduped).
  DistrictItem merge(DistrictItem other) {
    final existingNames = locations.map((l) => l.location).toSet();
    final merged = List<LocationItem>.from(locations);
    for (final loc in other.locations) {
      if (!existingNames.contains(loc.location)) {
        merged.add(loc);
        existingNames.add(loc.location);
      }
    }
    return DistrictItem(district: district, locations: merged);
  }
}

// ── State with its districts ──────────────────────────
class StateItem {
  final String state;
  final List<DistrictItem> districts;

  StateItem({
    required this.state,
    required this.districts,
  });

  /// Builds a [StateItem] from the API shape:
  /// { "state": "kerala", "districts": [ {...}, ... ] }
  factory StateItem.fromJson(Map<String, dynamic> json) {
    final rawDistricts = (json['districts'] as List<dynamic>? ?? []);
    return StateItem(
      state: json['state']?.toString() ?? '',
      districts: rawDistricts
          .map((d) => DistrictItem.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }
}