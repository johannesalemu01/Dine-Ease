import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dine_ease/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRepository {
  final ApiService _apiService;

  UserRepository(this._apiService);

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _apiService.get('/users/profile');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw Exception('Backend returned ${response.statusCode}: ${response.body}');
    } on SocketException catch (e) {
      throw Exception('Network error: $e');
    } on TimeoutException catch (e) {
      throw Exception('Connection timed out: $e');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<List<dynamic>> getLoyaltyHistory() async {
    try {
      final response = await _apiService.get('/loyalty/history');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw Exception('Backend returned ${response.statusCode}: ${response.body}');
    } on SocketException catch (e) {
      throw Exception('Network error: $e');
    } on TimeoutException catch (e) {
      throw Exception('Connection timed out: $e');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.patch('/users/profile', data);
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ updateProfile error: $e');
      return false;
    }
  }

  Future<bool> updatePreferences(Map<String, dynamic> prefs) async {
    try {
      final response = await _apiService.patch('/users/preferences', prefs);
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ updatePreferences error: $e');
      return false;
    }
  }

  Future<bool> deleteAccount() async {
    try {
      final response = await _apiService.delete('/users/account');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ deleteAccount error: $e');
      return false;
    }
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return UserRepository(apiService);
});
