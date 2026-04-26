import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApiService {
  late final String baseUrl;
  static const Duration _timeout = Duration(seconds: 30);

  ApiService() {
    // 1. Start with the hardcoded production fallback
    String finalUrl = 'https://mesob-backend-b6cu.onrender.com/api';

    // 2. Try to load from .env (this should be the primary source)
    try {
      if (dotenv.isInitialized && dotenv.env.containsKey('BACKEND_URL')) {
        finalUrl = dotenv.env['BACKEND_URL']!;
      } else {
        // 3. Platform-specific defaults for local development (if .env is missing)
        try {
          if (Platform.isAndroid) {
            finalUrl = 'http://10.0.2.2:8000/api';
          } else if (Platform.isIOS || Platform.isMacOS) {
            finalUrl = 'http://localhost:8000/api';
          }
        } catch (_) {}
      }
    } catch (_) {}

    // Strip trailing slashes
    baseUrl = finalUrl.endsWith('/') ? finalUrl.substring(0, finalUrl.length - 1) : finalUrl;
    debugPrint('🌐 ApiService v2 initialized with baseUrl: $baseUrl');
  }

  /// Returns a user-friendly diagnostic message for common connectivity errors.
  String _friendlyError(Object e) {
    if (e is SocketException) {
      return 'Cannot reach server at $baseUrl. Is the backend running & device on the same Wi-Fi?';
    } else if (e is TimeoutException) {
      return 'Request to $baseUrl timed out after ${_timeout.inSeconds}s.';
    }
    return e.toString();
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
      debugPrint('❌ GET $url failed: ${_friendlyError(e)}');
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
      debugPrint('❌ POST $url failed: ${_friendlyError(e)}');
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
      debugPrint('❌ PATCH $url failed: ${_friendlyError(e)}');
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
      debugPrint('❌ DELETE $url failed: ${_friendlyError(e)}');
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
      debugPrint('❌ GET $uri failed: ${_friendlyError(e)}');
      rethrow;
    }
  }

  Future<http.Response> getNearbyRestaurants(double lat, double lng, {int radius = 10000}) async {
    debugPrint('🍽️ Fetching nearby restaurants at ($lat, $lng) within ${radius}m');
    return getWithParams('/restaurants/nearby', {
      'lat': lat.toString(),
      'lng': lng.toString(),
      'radius': radius.toString(),
    });
  }
}

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());
