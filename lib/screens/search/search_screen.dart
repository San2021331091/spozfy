import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spozfy/controllers/search_controller.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchControllerX());
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Search",
          style: GoogleFonts.acme(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [
          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),

              child: TextField(
                controller: controller.searchController,
                onChanged: controller.search,
                cursorColor: Colors.black,

                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  letterSpacing: 0.4,
                ),

                decoration: InputDecoration(
                  hintText: "Search match, league, team...",

                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),

                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.grey.shade700,
                    size: 26,
                  ),

                  suffixIcon: IconButton(
                    onPressed: () {
                      controller.searchController.clear();
                      controller.search('');
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  filled: true,
                  fillColor: Colors.grey.shade200,

                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 20,
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: Colors.grey.shade600,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // MATCH LIST
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.filteredMatches.isEmpty) {
                return Center(
                  child: Text(
                    "No Results Found",
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: controller.filteredMatches.length,

                itemBuilder: (context, index) {
                  final match =
                      controller.filteredMatches[index];

                  final teams = match['teamInfo'] ?? [];

                  final team1 = teams.isNotEmpty
                      ? teams[0]['shortname'] ?? ''
                      : '';

                  final team2 = teams.length > 1
                      ? teams[1]['shortname'] ?? ''
                      : '';

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),

                    child: Card(
                      elevation: 2,

                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16),
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(14),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [
                            Text(
                              match['name'] ?? '',
                              style: GoogleFonts.acme(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              match['series'] ?? '',
                              style: GoogleFonts.acme(
                                color: Colors.grey.shade700,
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "$team1 vs $team2",
                              style: GoogleFonts.acme(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}