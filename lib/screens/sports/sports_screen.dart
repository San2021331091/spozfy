import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:spozfy/controllers/sports_controller.dart';
import 'package:spozfy/screens/channel_play/channel_play_screen.dart';
import 'package:spozfy/services/startup_service.dart';


class SportsScreen extends StatefulWidget {
  const SportsScreen({super.key});

  @override
  State<SportsScreen> createState() =>
      _SportsScreenState();
}

class _SportsScreenState extends State<SportsScreen> {
  final controller = Get.put(SportsController());

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
      () async {
        await StartAppService.showInterstitialAd();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Sports' Channels",
          style: GoogleFonts.acme(
            color: Colors.white,
            fontWeight: FontWeight.bold,
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

        return LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;

            int crossAxisCount = 4;

            if (width > 1200) {
              crossAxisCount = 8;
            } else if (width > 900) {
              crossAxisCount = 6;
            } else if (width > 600) {
              crossAxisCount = 5;
            } else {
              crossAxisCount = 4;
            }

            return GridView.builder(
              padding: const EdgeInsets.all(12),

              itemCount: controller.channels.length,

              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 17,
                mainAxisSpacing: 16,
                childAspectRatio: 0.72,
              ),

              itemBuilder: (context, index) {
                final channel =
                    controller.channels[index];

                return Column(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(
                            () => ChannelPlayScreen(
                              id: channel.id,
                            ),
                          );
                        },

                        child: CachedNetworkImage(
                          imageUrl: channel.image,

                          fit: BoxFit.contain,

                          placeholder:
                              (context, url) =>
                                  const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          ),

                          errorWidget:
                              (context, url, error) {
                            return const Center(
                              child: Icon(
                                Icons.sports,
                                color: Colors.white,
                                size: 40,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      channel.name,

                      maxLines: 3,

                      overflow: TextOverflow.ellipsis,

                      textAlign: TextAlign.center,

                      style: GoogleFonts.acme(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      }),
    );
  }
}