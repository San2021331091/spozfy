import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:spozfy/components/channel_filter/channels_filter_screen.dart';
import 'package:spozfy/controllers/category_controller.dart';
import 'package:spozfy/services/startup_service.dart';


class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() =>
      _CategoriesScreenState();
}

class _CategoriesScreenState
    extends State<CategoriesScreen> {
  final controller = Get.put(CategoryController());

  @override
  void initState() {
    super.initState();

    // Show rewarded ad when screen opens
    Future.delayed(
      const Duration(seconds: 1),
      () async {
        await StartAppService.showRewardedAd();
      },
    );
  }

  IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'football':
        return Icons.sports_soccer;

      case 'golf':
        return Icons.sports_golf;

      case 'tennis':
        return Icons.sports_tennis;

      case 'motorsports':
        return Icons.directions_car;

      case 'water sports':
        return Icons.surfing;

      case 'combat':
        return Icons.sports_mma;

      case 'bowling':
        return Icons.sports;

      case 'poker':
        return Icons.casino;

      case 'athletics':
        return Icons.directions_run;

      case 'general sports':
        return Icons.tv;

      case 'women sports':
        return Icons.female;

      case 'multi sports':
        return Icons.sports;

      case 'extreme sports':
        return Icons.skateboarding;

      default:
        return Icons.sports_basketball;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,

        title: Text(
          "Categories",

          style: GoogleFonts.acme(
            color: Colors.white,
            fontSize: 28,
          ),
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(14),

          itemCount: controller.categories.length,

          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.1,
          ),

          itemBuilder: (context, index) {
            final category =
                controller.categories[index];

            return GestureDetector(
              onTap: () {
                Get.to(
                  () => ChannelsFilterScreen(
                    id: category.id,
                    category: category.name,
                  ),
                );
              },

              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xff111111),

                  borderRadius:
                      BorderRadius.circular(18),

                  border: Border.all(
                    color: Colors.white10,
                  ),
                ),

                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [
                    Icon(
                      getCategoryIcon(
                        category.name,
                      ),

                      color: Colors.white,
                      size: 48,
                    ),

                    const SizedBox(height: 16),

                    Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),

                      child: Text(
                        category.name,

                        textAlign:
                            TextAlign.center,

                        style:
                            GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}