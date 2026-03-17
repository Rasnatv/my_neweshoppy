// ─────────────────────────────────────────────────────────────
//  Model: AdvertisementModel
//  Covers both get-single-advertisement and update-advertisement
// ─────────────────────────────────────────────────────────────

class updateAdvertisementModel {
  final String id;
  final String advertisement;
  final String bannerImage;
  final String createdByType;
  final String createdById;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const updateAdvertisementModel({
    required this.id,
    required this.advertisement,
    required this.bannerImage,
    required this.createdByType,
    required this.createdById,
    this.createdAt,
    this.updatedAt,
  });

  // ── Deserialise from JSON ──────────────────────────────────
  factory updateAdvertisementModel.fromJson(Map<String, dynamic> json) {
    return updateAdvertisementModel(
      id: json['id']?.toString() ?? '',
      advertisement: json['advertisement']?.toString() ?? '',
      bannerImage: json['banner_image']?.toString() ?? '',
      createdByType: json['created_by_type']?.toString() ?? '',
      createdById: json['created_by_id']?.toString() ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  // ── Serialise to JSON ──────────────────────────────────────
  Map<String, dynamic> toJson() => {
    'id': id,
    'advertisement': advertisement,
    'banner_image': bannerImage,
    'created_by_type': createdByType,
    'created_by_id': createdById,
    if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
  };

  // ── copyWith ───────────────────────────────────────────────
  updateAdvertisementModel copyWith({
    String? id,
    String? advertisement,
    String? bannerImage,
    String? createdByType,
    String? createdById,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      updateAdvertisementModel(
        id: id ?? this.id,
        advertisement: advertisement ?? this.advertisement,
        bannerImage: bannerImage ?? this.bannerImage,
        createdByType: createdByType ?? this.createdByType,
        createdById: createdById ?? this.createdById,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  String toString() =>
      'AdvertisementModel(id: $id, advertisement: $advertisement)';
}

// ─────────────────────────────────────────────────────────────
//  Wrapper: API response envelope
// ─────────────────────────────────────────────────────────────

class updateAdvertisementResponse {
  final String status;
  final String statusCode;
  final String message;
  final updateAdvertisementModel? data;

  const updateAdvertisementResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    this.data,
  });

  bool get isSuccess => status == '1' && statusCode == '200';

  factory updateAdvertisementResponse.fromJson(Map<String, dynamic> json) {
    return updateAdvertisementResponse(
      status: json['status']?.toString() ?? '0',
      statusCode: json['status_code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: json['data'] != null
          ? updateAdvertisementModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}



