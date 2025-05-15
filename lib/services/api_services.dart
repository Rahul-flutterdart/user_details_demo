import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/user_response_model.dart';

class ApiService {
  static const String _baseUrl = 'https://reqres.in/api';
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'x-api-key': 'reqres-free-v1'
  };

  Future<UserResponse> fetchUsers({int page = 2}) async {
    final url = Uri.parse('$_baseUrl/users?page=$page');
    try {
      final response = await _retryRequest(() => http.get(url, headers: _headers));

      // final response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return UserResponse.fromJson(json);
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
  Future<http.Response> _retryRequest(Future<http.Response> Function() requestFn, {int retries = 3}) async {
    int attempt = 0;
    while (true) {
      try {
        final response = await requestFn();
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return response;
        } else {
          throw Exception('HTTP ${response.statusCode}');
        }
      } catch (e) {
        if (++attempt >= retries) rethrow;
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
  }

  Future<User> fetchUserById(int id) async {
    final url = Uri.parse('$_baseUrl/users/$id');
    try {
      final response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return User.fromJson(json['data']);
      } else {
        throw Exception('Failed to load user: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
