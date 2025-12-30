import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dine_ease/models/booking.dart';
import 'package:dine_ease/models/restaurant.dart';
import 'package:dine_ease/services/api_service.dart';

class BookingRepository {
  final ApiService _apiService;

  BookingRepository(this._apiService);

  /// Safely decodes a JSON list from a response body, returning [] on failure.
  List<dynamic> _safeDecodeList(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is List) return decoded;
      debugPrint('⚠️ Expected JSON list but got: ${decoded.runtimeType}');
      return [];
    } catch (e) {
      debugPrint('⚠️ JSON decode failed: $e');
      return [];
    }
  }

  Future<List<Restaurant>> getRestaurants() async {
    try {
      final response = await _apiService.get('/restaurants');
      if (response.statusCode == 200) {
        final data = _safeDecodeList(response.body);
        return data.map((json) => Restaurant.fromJson(json)).toList();
      }
      debugPrint('⚠️ getRestaurants returned status ${response.statusCode}');
      return [];
    } on SocketException catch (e) {
      debugPrint('🔌 getRestaurants — no connection: $e');
      return [];
    } catch (e) {
      debugPrint('❌ getRestaurants error: $e');
      return [];
    }
  }

  Future<List<Restaurant>> getNearbyRestaurants(double lat, double lng, {int radius = 10000}) async {
    try {
      final response = await _apiService.getNearbyRestaurants(lat, lng, radius: radius);
      if (response.statusCode == 200) {
        final data = _safeDecodeList(response.body);
        return data.map((json) => Restaurant.fromJson(json)).toList();
      }
      debugPrint('⚠️ getNearbyRestaurants returned status ${response.statusCode}');
      return [];
    } on SocketException catch (e) {
      debugPrint('🔌 getNearbyRestaurants — no connection: $e');
      return [];
    } catch (e) {
      debugPrint('❌ getNearbyRestaurants error: $e');
      return [];
    }
  }

  Future<List<Booking>> getUserBookings() async {
    try {
      final response = await _apiService.get('/bookings/my-bookings');
      if (response.statusCode == 200) {
        final data = _safeDecodeList(response.body);
        return data.map((json) => Booking.fromJson(json)).toList();
      }
      debugPrint('⚠️ getUserBookings returned status ${response.statusCode}');
      return [];
    } on SocketException catch (e) {
      debugPrint('🔌 getUserBookings — no connection: $e');
      return [];
    } catch (e) {
      debugPrint('❌ getUserBookings error: $e');
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
      debugPrint('⚠️ createBooking returned status ${response.statusCode}: ${response.body}');
      return null;
    } catch (e) {
      debugPrint('❌ createBooking error: $e');
      return null;
    }
  }

  Future<bool> cancelBooking(String bookingId) async {
    try {
      final response = await _apiService.patch('/bookings/cancel/$bookingId', {});
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ cancelBooking error: $e');
      return false;
    }
  }
}

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return BookingRepository(apiService);
});
