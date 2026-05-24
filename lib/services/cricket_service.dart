import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spozfy/networking/dio_client.dart';

class CricketService {
  final DioClient _client = DioClient();

  // ✅ Safe API key (never null)
  final String apiKey = dotenv.env['CRICKET_API_KEY'] ?? "";

  // ================= LIVE / CURRENT =================
  Future<List<dynamic>> getLiveMatches() async {
    try {
      final response = await _client.dio.get(
        "/currentMatches",
        queryParameters: {
          "apikey": apiKey,
          "offset": 0,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map && data['data'] != null) {
          return data['data'];
        }
      }

      return [];
    } catch (e) {
      print("❌ Live matches error: $e");
      return [];
    }
  }

  // ================= UPCOMING =================
  Future<List<dynamic>> getUpcomingMatches() async {
    try {
      final response = await _client.dio.get(
        "/upcomingMatches",
        queryParameters: {
          "apikey": apiKey,
          "offset": 0,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map && data['data'] != null) {
          return data['data'];
        }
      }

      return [];
    } catch (e) {
      print("❌ Upcoming matches error: $e");
      return [];
    }
  }

  // ================= RECENT / FINISHED =================
  Future<List<dynamic>> getRecentMatches() async {
    try {
      final response = await _client.dio.get(
        "/matches",
        queryParameters: {
          "apikey": apiKey,
          "offset": 0,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map && data['data'] != null) {
          return data['data'];
        }
      }

      return [];
    } catch (e) {
      debugPrint("❌ Recent matches error: $e");
      return [];
    }
  }
}