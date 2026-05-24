import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spozfy/components/card/match_card.dart';
import 'package:spozfy/controllers/match_controller.dart';

class MatchList extends StatelessWidget {
  MatchList({super.key});

  final MatchController controller = Get.put(MatchController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (controller.error.isNotEmpty) {
        return Center(
          child: Text(controller.error.value),
        );
      }

      if (controller.filteredMatches.isEmpty) {
        return const Center(
          child: Text("No matches found"),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: controller.filteredMatches.length,
        itemBuilder: (context, index) {
          final match = controller.filteredMatches[index];

          final teams = match['teams'] ?? [];

          final league = (match['name'] ??
                  match['series'] ??
                  match['matchType'] ??
                  '')
              .toString()
              .trim();

          final matchTime =
              (match['dateTimeGMT'] ?? '').toString().trim();

          final status =
              (match['status'] ?? 'Live').toString().trim();

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: MatchCard(
              league: league.isEmpty
                  ? "Cricket Match"
                  : league,

              team1: teams.isNotEmpty
                  ? teams[0].toString()
                  : "Team A",

              team2: teams.length > 1
                  ? teams[1].toString()
                  : "Team B",

              time: matchTime.isEmpty
                  ? "N/A"
                  : matchTime,

              status: status,

              icon1: Icons.sports_cricket,
              icon2: Icons.sports_cricket,
            ),
          );
        },
      );
    });
  }
}