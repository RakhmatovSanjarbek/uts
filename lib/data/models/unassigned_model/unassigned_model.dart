class UnassignedCargoModel {
  final int id;
  final String trackCode;
  final String flightName;
  final DateTime createdAt;
  final String? note;

  UnassignedCargoModel({
    required this.id,
    required this.trackCode,
    required this.flightName,
    required this.createdAt,
    this.note,
  });

  factory UnassignedCargoModel.fromJson(Map<String, dynamic> json) {
    return UnassignedCargoModel(
      id: json['id'],
      trackCode: json['track_code'],
      flightName: json['flight_name'],
      createdAt: DateTime.parse(json['created_at']),
      note: json['note'],
    );
  }
}

class UnassignedCargoListModel {
  final List<UnassignedCargoModel> items;
  final int totalCount;
  final String? nextPage;

  UnassignedCargoListModel({
    required this.items,
    required this.totalCount,
    this.nextPage,
  });
}