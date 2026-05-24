import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spozfy/services/cricket_service.dart';

class SearchControllerX extends GetxController {
  final CricketService _service = CricketService();

  final TextEditingController searchController =
      TextEditingController();

  RxBool isLoading = false.obs;

  RxList<dynamic> allMatches = <dynamic>[].obs;
  RxList<dynamic> filteredMatches = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllMatches();
  }

  Future<void> fetchAllMatches() async {
    try {
      isLoading.value = true;

      final live = await _service.getLiveMatches();
      final upcoming = await _service.getUpcomingMatches();
      final recent = await _service.getRecentMatches();

      final combined = [
        ...live,
        ...upcoming,
        ...recent,
      ];

      allMatches.assignAll(combined);

      filteredMatches.assignAll(combined);
    } catch (e) {
      debugPrint("SEARCH ERROR => $e");
    } finally {
      isLoading.value = false;
    }
  }

  void search(String query) {
    if (query.trim().isEmpty) {
      filteredMatches.assignAll(allMatches);
      return;
    }

    final q = query.toLowerCase();

    final results = allMatches.where((match) {
      /// Match Name
      final matchName =
          (match['name'] ?? '')
              .toString()
              .toLowerCase();

      /// Series Name
      final seriesName =
          (match['series']?['name'] ?? '')
              .toString()
              .toLowerCase();

      /// Teams
      final teamInfo = match['teamInfo'] ?? [];

      bool teamMatched = false;

      for (var team in teamInfo) {
        final teamName =
            (team['name'] ?? '')
                .toString()
                .toLowerCase();

        final shortName =
            (team['shortname'] ?? '')
                .toString()
                .toLowerCase();

        if (teamName.contains(q) ||
            shortName.contains(q)) {
          teamMatched = true;
          break;
        }
      }

      return matchName.contains(q) ||
          seriesName.contains(q) ||
          teamMatched;
    }).toList();

    filteredMatches.assignAll(results);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}