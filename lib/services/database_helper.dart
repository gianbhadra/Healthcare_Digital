import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const _apiHostOverride = String.fromEnvironment('API_HOST');

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  String get baseUrl {
    if (_apiHostOverride.isNotEmpty) {
      return '${_apiHostOverride.replaceAll(RegExp(r'/$'), '')}/api';
    }
    if (kIsWeb) return 'http://localhost:3000/api';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000/api';
    }
    return 'http://localhost:3000/api';
  }

  DatabaseHelper._init();

  // --- Members CRUD ---
  Future<int> insertMember(Map<String, dynamic> member) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/members'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(member),
      );
      return response.statusCode == 201 ? 1 : 0;
    } catch (e) {
      print('Error insertMember: $e');
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> getMembers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/members'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Gagal memuat data member');
      }
    } catch (e) {
      print('Error getMembers: $e');
      return [];
    }
  }

  Future<int> updateMember(Map<String, dynamic> member, int id) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/members/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(member),
      );
      return response.statusCode == 200 ? 1 : 0;
    } catch (e) {
      print('Error updateMember: $e');
      return 0;
    }
  }

  Future<int> deleteMember(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/members/$id'));
      return response.statusCode == 204 ? 1 : 0;
    } catch (e) {
      print('Error deleteMember: $e');
      return 0;
    }
  }

  // --- Health History CRUD ---
  Future<int> insertHistory(Map<String, dynamic> history) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/history'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(history),
      );
      return response.statusCode == 201 ? 1 : 0;
    } catch (e) {
      print('Error insertHistory: $e');
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/history'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Gagal memuat riwayat kesehatan');
      }
    } catch (e) {
      print('Error getHistory: $e');
      return [];
    }
  }

  Future<int> updateHistory(Map<String, dynamic> history, int id) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/history/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(history),
      );
      return response.statusCode == 200 ? 1 : 0;
    } catch (e) {
      print('Error updateHistory: $e');
      return 0;
    }
  }

  Future<int> deleteHistory(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/history/$id'));
      return response.statusCode == 204 ? 1 : 0;
    } catch (e) {
      print('Error deleteHistory: $e');
      return 0;
    }
  }
}