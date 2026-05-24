import 'package:get/get.dart';
import 'filter_controller.dart';
import 'package:spozfy/services/cricket_service.dart';

class MatchController extends GetxController {
  final CricketService _service = CricketService();

  final matches = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  late final FilterController filterController;

  @override
  void onInit() {
    super.onInit();
    filterController = Get.find<FilterController>();
    fetchMatches();
  }

  Future<void> fetchMatches() async {
    try {
      isLoading(true);
      error('');

      final data = await _service.getLiveMatches();

      matches.assignAll(
        data.map<Map<String, dynamic>>(
          (e) => Map<String, dynamic>.from(e),
        ).toList(),
      );
    } catch (e) {
      error(e.toString());
    } finally {
      isLoading(false);
    }
  }

  /// ================= LIVE =================
  bool _isLive(Map<String, dynamic> match) {
    final status =
        (match['status'] ?? '').toString().toLowerCase();

    final started = match['matchStarted'] == true;
    final ended = match['matchEnded'] == true;

    return started &&
        !ended &&
        !status.contains("won") &&
        !status.contains("result") &&
        !status.contains("finished");
  }

  /// ================= RECENT =================
  bool _isRecent(Map<String, dynamic> match) {
    final status =
        (match['status'] ?? '').toString().toLowerCase();

    final ended = match['matchEnded'] == true;

    return ended ||
        status.contains("won") ||
        status.contains("result") ||
        status.contains("finished") ||
        status.contains("completed");
  }

  /// ================= UPCOMING =================
  bool _isUpcoming(Map<String, dynamic> match) {
    final started = match['matchStarted'] == true;

    final status =
        (match['status'] ?? '').toString().toLowerCase();

    final dateStr =
        (match['dateTimeGMT'] ?? '').toString();

    final date = DateTime.tryParse(dateStr);

    if (!started) {
      return true;
    }

    if (status.contains("not started") ||
        status.contains("scheduled") ||
        status.contains("fixture") ||
        status.contains("upcoming")) {
      return true;
    }

    if (date != null) {
      return date.isAfter(DateTime.now().toUtc());
    }

    return false;
  }

  /// ================= FILTER =================
  List<Map<String, dynamic>> get filteredMatches {
    final filter = filterController.selectedFilter.value;

    /// ALL
    if (filter == "All") {
      return matches;
    }

    /// LIVE
    if (filter == "Live") {
      return matches.where(_isLive).toList();
    }

    /// RECENT
    if (filter == "Recent") {
      return matches.where(_isRecent).toList();
    }

    /// UPCOMING
    if (filter == "Upcoming") {
      return matches.where(_isUpcoming).toList();
    }

    return matches;
  }
}