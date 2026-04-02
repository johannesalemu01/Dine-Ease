import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApiService {
  late final String baseUrl;

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
    final headers = await _getHeaders();
    return http.get(Uri.parse('$baseUrl$endpoint'), headers: headers);
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    return http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> patch(String endpoint, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    return http.patch(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> delete(String endpoint) async {
    final headers = await _getHeaders();
    return http.delete(Uri.parse('$baseUrl$endpoint'), headers: headers);
  }

  // Helper for GET requests with query parameters
  Future<http.Response> getWithParams(String endpoint, Map<String, String> params) async {
    final headers = await _getHeaders();
    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: params);
    return http.get(uri, headers: headers);
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
