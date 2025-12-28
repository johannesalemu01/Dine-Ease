import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApiService {
  late final String baseUrl;
  static const Duration _timeout = Duration(seconds: 10);

  ApiService() {
    final raw = dotenv.env['BACKEND_URL'] ?? 'http://10.42.0.10:5000/api';
    // Strip trailing slashes for consistent URL construction
    baseUrl = raw.endsWith('/') ? raw.substring(0, raw.length - 1) : raw;
    debugPrint('🌐 ApiService initialized with baseUrl: $baseUrl');
  }

  Future<Map<String, String>> _getHeaders() async {
    final session = Supabase.instance.client.auth.currentSession;
    final token = session?.accessToken;
    
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> get(String endpoint) async {
    final url = '$baseUrl$endpoint';
    debugPrint('📡 GET $url');
    final headers = await _getHeaders();
    try {
      final response = await http.get(Uri.parse(url), headers: headers).timeout(_timeout);
      debugPrint('📡 GET $url → ${response.statusCode}');
      return response;
    } catch (e) {
      debugPrint('❌ GET $url failed: $e');
      rethrow;
    }
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final url = '$baseUrl$endpoint';
    debugPrint('📡 POST $url');
    final headers = await _getHeaders();
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      ).timeout(_timeout);
      debugPrint('📡 POST $url → ${response.statusCode}');
      return response;
    } catch (e) {
      debugPrint('❌ POST $url failed: $e');
      rethrow;
    }
  }

  Future<http.Response> patch(String endpoint, Map<String, dynamic> body) async {
    final url = '$baseUrl$endpoint';
    debugPrint('📡 PATCH $url');
    final headers = await _getHeaders();
    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      ).timeout(_timeout);
      debugPrint('📡 PATCH $url → ${response.statusCode}');
      return response;
    } catch (e) {
      debugPrint('❌ PATCH $url failed: $e');
      rethrow;
    }
  }

  Future<http.Response> delete(String endpoint) async {
    final url = '$baseUrl$endpoint';
    debugPrint('📡 DELETE $url');
    final headers = await _getHeaders();
    try {
      final response = await http.delete(Uri.parse(url), headers: headers).timeout(_timeout);
      debugPrint('📡 DELETE $url → ${response.statusCode}');
      return response;
    } catch (e) {
      debugPrint('❌ DELETE $url failed: $e');
      rethrow;
    }
  }

  // Helper for GET requests with query parameters
  Future<http.Response> getWithParams(String endpoint, Map<String, String> params) async {
    final headers = await _getHeaders();
    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: params);
    debugPrint('📡 GET $uri');
    try {
      final response = await http.get(uri, headers: headers).timeout(_timeout);
      debugPrint('📡 GET $uri → ${response.statusCode}');
      return response;
    } catch (e) {
      debugPrint('❌ GET $uri failed: $e');
      rethrow;
    }
  }

  Future<http.Response> getNearbyRestaurants(double lat, double lng, {int radius = 5000}) async {
    return getWithParams('/restaurants/nearby', {
      'lat': lat.toString(),
      'lng': lng.toString(),
      'radius': radius.toString(),
    });
  }
}

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());
