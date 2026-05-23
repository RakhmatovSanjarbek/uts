class FlightModel {
  final int id;
  final String name;
  final String warehouseStart;
  final String warehouseEnd;
  final String warehousePeriod;
  final String arrivalDate;
  final String status;
  final String statusDisplay;
  final String? note;

  FlightModel({
    required this.id,
    required this.name,
    required this.warehouseStart,
    required this.warehouseEnd,
    required this.warehousePeriod,
    required this.arrivalDate,
    required this.status,
    required this.statusDisplay,
    this.note,
  });

  factory FlightModel.fromJson(Map<String, dynamic> json) {
    return FlightModel(
      id: json['id'],
      name: json['name'],
      warehouseStart: json['warehouse_start'],
      warehouseEnd: json['warehouse_end'],
      warehousePeriod: json['warehouse_period'],
      arrivalDate: json['arrival_date'],
      status: json['status'],
      statusDisplay: json['status_display'],
      note: json['note'],
    );
  }
}

class FlightListModel {
  final List<FlightModel> flights;
  final int totalCount;
  final String? nextPage;

  FlightListModel({
    required this.flights,
    required this.totalCount,
    this.nextPage,
  });
}
