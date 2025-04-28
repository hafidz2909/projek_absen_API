class IzinAbsenModel {
  final String? message;
  final IzinData? data;

  IzinAbsenModel({this.message, this.data});

  factory IzinAbsenModel.fromJson(Map<String, dynamic> json) {
    return IzinAbsenModel(
      message: json['message'],
      data: json['data'] != null ? IzinData.fromJson(json['data']) : null,
    );
  }
}

class IzinData {
  final int? id;
  final int? userId;
  final String? checkIn;
  final String? checkInLocation;
  final String? checkInAddress;
  final String? status;
  final String? alasanIzin;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  IzinData({
    this.id,
    this.userId,
    this.checkIn,
    this.checkInLocation,
    this.checkInAddress,
    this.status,
    this.alasanIzin,
    this.createdAt,
    this.updatedAt,
  });

  factory IzinData.fromJson(Map<String, dynamic> json) {
    return IzinData(
      id: json['id'],
      userId: json['user_id'],
      checkIn: json['check_in'],
      checkInLocation: json['check_in_location'],
      checkInAddress: json['check_in_address'],
      status: json['status'],
      alasanIzin: json['alasan_izin'],
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : null,
    );
  }
}
