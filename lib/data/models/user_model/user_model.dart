// data/models/user_model/user_model.dart
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final String? userId;
  final String phone;
  final String firstName;
  final String lastName;
  final String jshshir;
  final String passportSeries;
  final String birthDate;
  final String address;
  final String? passportFront;
  final String? passportBack;
  final String status;
  final String statusDisplay;
  final String? rejectionReason;
  final String? rejectionReasonDisplay;
  final String? rejectionNote;

  const UserModel({
    required this.id,
    this.userId,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.jshshir,
    required this.passportSeries,
    required this.birthDate,
    required this.address,
    this.passportFront,
    this.passportBack,
    required this.status,
    required this.statusDisplay,
    this.rejectionReason,
    this.rejectionReasonDisplay,
    this.rejectionNote,
  });

  static const String statusPending = 'pending';
  static const String statusApproved = 'approved';
  static const String statusRejected = 'rejected';

  bool get isApproved => status == statusApproved;
  bool get isPending => status == statusPending;
  bool get isRejected => status == statusRejected;
  bool get canUseFullFeatures => isApproved;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      userId: json['user_id'] ?? '',
      phone: json['phone'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      jshshir: json['jshshir'] ?? '',
      passportSeries: json['passport_series'] ?? '',
      birthDate: json['birth_date'] ?? '',
      address: json['address'] ?? '',
      passportFront: json['passport_front'],
      passportBack: json['passport_back'],
      status: json['status'] ?? 'pending',
      statusDisplay: json['status_display'] ?? 'Kutilmoqda',
      rejectionReason: json['rejection_reason'],
      rejectionReasonDisplay: json['rejection_reason_display'],
      rejectionNote: json['rejection_note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'phone': phone,
      'first_name': firstName,
      'last_name': lastName,
      'jshshir': jshshir,
      'passport_series': passportSeries,
      'birth_date': birthDate,
      'address': address,
      'passport_front': passportFront,
      'passport_back': passportBack,
      'status': status,
      'status_display': statusDisplay,
      'rejection_reason': rejectionReason,
      'rejection_reason_display': rejectionReasonDisplay,
      'rejection_note': rejectionNote,
    };
  }

  @override
  List<Object?> get props => [
    id, userId, phone, firstName, lastName, jshshir,
    passportSeries, birthDate, address, status, statusDisplay
  ];
}