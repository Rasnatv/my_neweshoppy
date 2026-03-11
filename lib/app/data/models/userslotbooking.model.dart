

Map<String, dynamic> _asMap(dynamic v) {
  if (v is Map<String, dynamic>) return v;
  if (v is Map) return v.map((k, val) => MapEntry(k.toString(), val));
  return {};
}

List<dynamic> _asList(dynamic v) => v is List ? v : [];

// ── 1. /restaurant/bookings ───────────────────────────────────────────────────

class MealSlot {
  final String mealType;
  final List<String> timeSlots;

  MealSlot({required this.mealType, required this.timeSlots});

  String get displayLabel =>
      mealType.isNotEmpty ? mealType[0].toUpperCase() + mealType.substring(1) : "";

  factory MealSlot.fromJson(dynamic raw) {
    final j = _asMap(raw);
    return MealSlot(
      mealType:  ((j["meal_type"] ?? "") as String).toLowerCase(),
      timeSlots: _asList(j["time_slots"]).map((e) => e.toString()).toList(),
    );
  }
}

class TimeSlotsResponseData {
  final List<MealSlot> meals;
  TimeSlotsResponseData({required this.meals});

  factory TimeSlotsResponseData.fromJson(dynamic raw) {
    final j = _asMap(raw);
    return TimeSlotsResponseData(
      meals: _asList(j["meals"]).map((m) => MealSlot.fromJson(m)).toList(),
    );
  }
}

class TimeSlotsResponse {
  final int status;
  final String message;
  final TimeSlotsResponseData? data;

  TimeSlotsResponse({required this.status, required this.message, this.data});

  factory TimeSlotsResponse.fromJson(dynamic raw) {
    final j = _asMap(raw);
    return TimeSlotsResponse(
      status:  (j["status"] as num?)?.toInt() ?? 0,
      message: (j["message"] ?? "") as String,
      data:    j["data"] != null ? TimeSlotsResponseData.fromJson(j["data"]) : null,
    );
  }
}

// ── 2. /get-tables-by-guests ──────────────────────────────────────────────────

class SeatingTableGroup {
  final String seatingType;
  final List<String> tables;

  SeatingTableGroup({required this.seatingType, required this.tables});

  String get displayLabel =>
      seatingType.isNotEmpty ? seatingType[0].toUpperCase() + seatingType.substring(1) : "";

  factory SeatingTableGroup.fromJson(dynamic raw) {
    final j = _asMap(raw);
    return SeatingTableGroup(
      seatingType: ((j["seating_type"] ?? "") as String).toLowerCase(),
      tables: ((j["table_name"] ?? "") as String)
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList(),
    );
  }
}

class GetTablesByGuestsResponse {
  final int status;
  final String message;
  final List<SeatingTableGroup> data;

  GetTablesByGuestsResponse({required this.status, required this.message, required this.data});

  factory GetTablesByGuestsResponse.fromJson(dynamic raw) {
    final j = _asMap(raw);
    return GetTablesByGuestsResponse(
      status:  (j["status"] as num?)?.toInt() ?? 0,
      message: (j["message"] ?? "") as String,
      data:    _asList(j["data"]).map((e) => SeatingTableGroup.fromJson(e)).toList(),
    );
  }
}

// ── 3. /restaurant-booking/confirm ───────────────────────────────────────────

class BookingEntry {
  final String seatingType;
  final String mealType;
  final String timeSlot;
  final String tableName;

  BookingEntry({
    required this.seatingType,
    required this.mealType,
    required this.timeSlot,
    required this.tableName,
  });

  Map<String, dynamic> toJson() => {
    "seating_type": seatingType,
    "meal_type":    mealType,
    "time_slot":    timeSlot,
    "table_name":   tableName,
  };
}

class ConfirmBookingRequest {
  final int restaurantId;
  final int guests;
  final String bookingDate;
  final List<BookingEntry> bookings;

  ConfirmBookingRequest({
    required this.restaurantId,
    required this.guests,
    required this.bookingDate,
    required this.bookings,
  });

  Map<String, dynamic> toJson() => {
    "restaurant_id": restaurantId,
    "guests":        guests,
    "booking_date":  bookingDate,
    "bookings":      bookings.map((b) => b.toJson()).toList(),
  };
}

class ConfirmedBookingEntry {
  final String mealType;
  final String seatingType;
  final String timeSlot;
  final String selectedTable;

  ConfirmedBookingEntry({
    required this.mealType,
    required this.seatingType,
    required this.timeSlot,
    required this.selectedTable,
  });

  factory ConfirmedBookingEntry.fromJson(dynamic raw) {
    final j = _asMap(raw);
    return ConfirmedBookingEntry(
      mealType:      (j["meal_type"]      ?? "") as String,
      seatingType:   (j["seating_type"]   ?? "") as String,
      timeSlot:      (j["time_slot"]      ?? "") as String,
      selectedTable: (j["selected_table"] ?? "") as String,
    );
  }
}

class ConfirmBookingResponseData {
  final int restaurantId;
  final int numberOfGuests;
  final String bookingDate;
  final List<ConfirmedBookingEntry> bookings;

  ConfirmBookingResponseData({
    required this.restaurantId,
    required this.numberOfGuests,
    required this.bookingDate,
    required this.bookings,
  });

  factory ConfirmBookingResponseData.fromJson(dynamic raw) {
    final j = _asMap(raw);
    return ConfirmBookingResponseData(
      restaurantId:   (j["restaurant_id"]    as num?)?.toInt() ?? 0,
      numberOfGuests: (j["number_of_guests"] as num?)?.toInt() ?? 0,
      bookingDate:    (j["booking_date"]     ?? "") as String,
      bookings: _asList(j["bookings"])
          .map((e) => ConfirmedBookingEntry.fromJson(e))
          .toList(),
    );
  }
}

class ConfirmBookingResponse {
  final int status;
  final String message;
  final ConfirmBookingResponseData? data;

  ConfirmBookingResponse({required this.status, required this.message, this.data});

  factory ConfirmBookingResponse.fromJson(dynamic raw) {
    final j = _asMap(raw);
    return ConfirmBookingResponse(
      status:  (j["status"] as num?)?.toInt() ?? 0,
      message: (j["message"] ?? "") as String,
      data:    j["data"] != null ? ConfirmBookingResponseData.fromJson(j["data"]) : null,
    );
  }
}

// ── 4. Cart summary ───────────────────────────────────────────────────────────

class CartBookingItem {
  final String seatingType;
  final String mealType;
  final String timeSlot;
  final String tableName;

  CartBookingItem({
    required this.seatingType,
    required this.mealType,
    required this.timeSlot,
    required this.tableName,
  });

  Map<String, dynamic> toJson() => {
    "seating_type": seatingType,
    "meal_type":    mealType,
    "time_slot":    timeSlot,
    "table_name":   tableName,
  };

  factory CartBookingItem.fromJson(dynamic raw) {
    final j = _asMap(raw);
    return CartBookingItem(
      seatingType: (j["seating_type"] ?? "") as String,
      mealType:    (j["meal_type"]    ?? "") as String,
      timeSlot:    (j["time_slot"]    ?? "") as String,
      tableName:   (j["table_name"]   ?? "") as String,
    );
  }
}

class BookingSummary {
  final int restaurantId;
  final int guests;
  final String bookingDate;
  final List<CartBookingItem> bookings;

  BookingSummary({
    required this.restaurantId,
    required this.guests,
    required this.bookingDate,
    required this.bookings,
  });

  Map<String, dynamic> toJson() => {
    "restaurant_id": restaurantId,
    "guests":        guests,
    "booking_date":  bookingDate,
    "bookings":      bookings.map((b) => b.toJson()).toList(),
  };

  factory BookingSummary.fromJson(dynamic raw) {
    final j = _asMap(raw);
    return BookingSummary(
      restaurantId: (j["restaurant_id"] as num?)?.toInt() ?? 0,
      guests:       (j["guests"]        as num?)?.toInt() ?? 0,
      bookingDate:  (j["booking_date"]  ?? "") as String,
      bookings: _asList(j["bookings"])
          .map((e) => CartBookingItem.fromJson(e))
          .toList(),
    );
  }
}