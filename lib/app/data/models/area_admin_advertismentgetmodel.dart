//
// class AreaAdmingetAdvertisementModel {
//   final int id;
//   final String advertisement;
//   final String mainLocation;
//   final String bannerImage;
//   final DateTime createdAt;
//   final String createdByType; // "admin" | "merchant" | "area_admin"
//   final String createdById;
//
//   AreaAdmingetAdvertisementModel({
//     required this.id,
//     required this.advertisement,
//     required this.mainLocation,
//     required this.bannerImage,
//     required this.createdAt,
//     required this.createdByType,
//     required this.createdById,
//   });
//
//   factory AreaAdmingetAdvertisementModel.fromJson(Map<String, dynamic> json) {
//     return AreaAdmingetAdvertisementModel(
//       id: int.tryParse(json['id'].toString()) ?? 0,
//       advertisement: json['advertisement']?.toString() ?? '',
//       mainLocation: json['main_location']?.toString() ?? '',
//       bannerImage: json['banner_image']?.toString() ?? '',
//       createdAt: _parseDate(json['created_at']),
//       createdByType: json['created_by_type']?.toString() ?? '',
//       createdById: json['created_by_id']?.toString() ?? '',
//     );
//   }
//
//   static DateTime _parseDate(dynamic raw) {
//     if (raw == null) return DateTime.now();
//     try {
//       return DateTime.parse(raw.toString());
//     } catch (_) {
//       return DateTime.now();
//     }
//   }
//
//   /// Only area_admin's own posts can be edited/deleted
//   bool get canEditOrDelete => createdByType == 'area_admin' || createdByType == 'merchant';
//
//   /// Label shown in the location badge
//   String get postedByLabel {
//     switch (createdByType) {
//       case 'admin':
//         return 'ADMIN';
//       case 'merchant':
//         return 'MERCHANT';
//       default:
//         return mainLocation.toUpperCase();
//     }
//   }
//
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'advertisement': advertisement,
//     'main_location': mainLocation,
//     'banner_image': bannerImage,
//     'created_at': createdAt.toIso8601String(),
//     'created_by_type': createdByType,
//     'created_by_id': createdById,
//   };
// }
// lib/data/models/area_admin_advertismentgetmodel.dart

class AreaAdmingetAdvertisementModel {
  final int id;
  final String advertisement;
  final String mainLocation;
  final String bannerImage;
  final DateTime createdAt;
  final String createdByType;
  final String createdById;

  AreaAdmingetAdvertisementModel({
    required this.id,
    required this.advertisement,
    required this.mainLocation,
    required this.bannerImage,
    required this.createdAt,
    required this.createdByType,
    required this.createdById,
  });

  factory AreaAdmingetAdvertisementModel.fromJson(Map<String, dynamic> json) {
    return AreaAdmingetAdvertisementModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      advertisement: json['advertisement']?.toString() ?? '',
      mainLocation: json['main_location']?.toString() ?? '',
      bannerImage: json['banner_image']?.toString() ?? '',
      createdAt: _parseDate(json['created_at']),
      createdByType: json['created_by_type']?.toString() ?? '',
      createdById: json['created_by_id']?.toString() ?? '',
    );
  }

  static DateTime _parseDate(dynamic raw) {
    if (raw == null) return DateTime.fromMillisecondsSinceEpoch(0);
    try {
      return DateTime.parse(raw.toString());
    } catch (_) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }

  // Only area_admin's own posts can be edited/deleted
  bool get canEditOrDelete => createdByType == 'area_admin';

  String get postedByLabel {
    switch (createdByType) {
      case 'admin':
        return 'ADMIN';
      case 'merchant':
        return 'MERCHANT';
      default:
        return mainLocation.toUpperCase();
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'advertisement': advertisement,
    'main_location': mainLocation,
    'banner_image': bannerImage,
    'created_at': createdAt.toIso8601String(),
    'created_by_type': createdByType,
    'created_by_id': createdById,
  };
}