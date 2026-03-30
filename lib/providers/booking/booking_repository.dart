import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dine_ease/models/booking.dart';
import 'package:dine_ease/models/restaurant.dart';
import 'package:dine_ease/services/api_service.dart';

class BookingRepository {
  final ApiService _apiService;

  BookingRepository(this._apiService);

  Future<List<Restaurant>> getRestaurants() async {
    try {
      final response = await _apiService.get('/bookings/restaurants');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Restaurant.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<Booking>> getUserBookings() async {
    try {
      final response = await _apiService.get('/bookings/my-bookings');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Booking.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Booking?> createBooking({
    required String restaurantId,
    required DateTime date,
    required String time,
    required int guests,
    String? specialRequests,
  }) async {
    try {
      final response = await _apiService.post('/bookings', {
        'restaurant': restaurantId,
        'date': date.toIso8601String(),
        'time': time,
        'guests': guests,
        'specialRequests': specialRequests ?? '',
      });

      if (response.statusCode == 201) {
        return Booking.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> cancelBooking(String bookingId) async {
    try {
      final response = await _apiService.patch('/bookings/cancel/$bookingId', {});
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return BookingRepository(apiService);
});
