import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class NetworkStreamScreen extends StatefulWidget {
  const NetworkStreamScreen({super.key});

  @override
  State<NetworkStreamScreen> createState() => _NetworkStreamScreenState();
}

class _NetworkStreamScreenState extends State<NetworkStreamScreen> {
  final TextEditingController urlController = TextEditingController();

  VideoPlayerController? videoController;

  bool isLoading = false;
  bool isPlaying = false;

  Future<void> playStream() async {
    final url = urlController.text.trim();

    if (url.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter stream URL",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      await videoController?.dispose();

      videoController = VideoPlayerController.networkUrl(
        Uri.parse(url),
      );

      await videoController!.initialize();

      await videoController!.play();

      setState(() {
        isPlaying = true;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      Get.snackbar(
        "Error",
        "Invalid stream URL",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    urlController.dispose();
    videoController?.dispose();
    super.dispose();
  }

  void openStreamDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xff3A4151),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: Text(
            "Network Stream",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SizedBox(
            width: 320,
            child: TextField(
              controller: urlController,
              style: GoogleFonts.acme(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: "Stream URL",
                hintStyle: GoogleFonts.acme(
                  color: Colors.white54,
                ),
                filled: true,
                fillColor: const Color(0xff4B5263),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(
                    color: Colors.white24,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(
                    color: Colors.greenAccent,
                  ),
                ),
                suffixIcon: const Icon(
                  Icons.link,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "CANCEL",
                style: GoogleFonts.poppins(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await playStream();
              },
              child: Text(
                "PLAY",
                style: GoogleFonts.poppins(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Network Stream",
          style: GoogleFonts.acme(
            color: Colors.white,
            fontSize: 28,
          ),
        ),
        actions: [
          IconButton(
            onPressed: openStreamDialog,
            icon: const Icon(
              Icons.add_link,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : isPlaying &&
                    videoController != null &&
                    videoController!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: videoController!.value.aspectRatio,
                    child: VideoPlayer(
                      videoController!,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.wifi_tethering,
                        color: Colors.white38,
                        size: 80,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Add Network Stream URL",
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: openStreamDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff1DB954),
                          foregroundColor: Colors.white,
                          elevation: 6,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(
                          Icons.link,
                          size: 22,
                        ),
                        label: Text(
                          "Open Stream",
                          style: GoogleFonts.acme(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
      floatingActionButton: isPlaying
          ? FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () {
                if (videoController!.value.isPlaying) {
                  videoController!.pause();
                } else {
                  videoController!.play();
                }

                setState(() {});
              },
              child: Icon(
                videoController!.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
              ),
            )
          : null,
    );
  }
}
