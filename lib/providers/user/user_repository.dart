import 'dart:convert';
import 'package:dine_ease/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRepository {
  final ApiService _apiService;

  UserRepository(this._apiService);

  Future<Map<String, dynamic>?> getProfile() async {
    final response = await _apiService.get('/users/profile');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    final response = await _apiService.patch('/users/profile', data);
    return response.statusCode == 200;
  }

  Future<bool> updatePreferences(Map<String, dynamic> prefs) async {
    final response = await _apiService.patch('/users/preferences', prefs);
    return response.statusCode == 200;
  }

  Future<bool> deleteAccount() async {
    final response = await _apiService.delete('/users/account');
    return response.statusCode == 200;
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return UserRepository(apiService);
});
