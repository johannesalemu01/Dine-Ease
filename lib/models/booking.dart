import 'package:dine_ease/models/restaurant.dart';

class Booking {
  final String id;
  final String user;
  final Restaurant? restaurant;
  final String? restaurantId;
  final DateTime date;
  final String time;
  final int guests;
  final String status;
  final String specialRequests;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.user,
    this.restaurant,
    this.restaurantId,
    required this.date,
    required this.time,
    required this.guests,
    required this.status,
    required this.specialRequests,
    required this.createdAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'],
      user: json['user'],
      restaurant: json['restaurant'] != null && json['restaurant'] is Map<String, dynamic>
          ? Restaurant.fromJson(json['restaurant'])
          : null,
      restaurantId: json['restaurant'] is String ? json['restaurant'] : null,
      date: DateTime.parse(json['date']),
      time: json['time'],
      guests: json['guests'],
      status: json['status'],
      specialRequests: json['specialRequests'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
