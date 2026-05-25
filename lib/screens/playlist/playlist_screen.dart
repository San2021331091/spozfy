import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class PlaylistModel {
  final String url;
  final VideoPlayerController controller;

  PlaylistModel({
    required this.url,
    required this.controller,
  });
}

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() =>
      _PlaylistScreenState();
}

class _PlaylistScreenState
    extends State<PlaylistScreen> {
  final TextEditingController urlController =
      TextEditingController();

  final List<PlaylistModel> playlists = [];

  bool isLoading = false;

  Future<void> addPlaylist() async {
    final url = urlController.text.trim();

    if (url.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter playlist url",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      final controller =
          VideoPlayerController.networkUrl(
        Uri.parse(url),
      );

      await controller.initialize();

      await controller.play();

      controller.setLooping(true);

      playlists.add(
        PlaylistModel(
          url: url,
          controller: controller,
        ),
      );

      urlController.clear();

      setState(() {
        isLoading = false;
      });

      Get.snackbar(
        "Success",
        "Playlist added successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      Get.snackbar(
        "Error",
        "Could not play playlist",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void showAddPlaylistDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xff3A4151),

          title: Text(
            "Add Playlist",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),

          content: TextField(
            controller: urlController,

            style: GoogleFonts.poppins(
              color: Colors.white,
            ),

            decoration: InputDecoration(
              hintText: "Enter m3u8/mp4 url",

              hintStyle: GoogleFonts.poppins(
                color: Colors.white54,
              ),

              filled: true,
              fillColor: const Color(0xff4B5263),

              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(8),
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.white24,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.cyanAccent,
                ),
              ),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },

              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                Get.back();
                await addPlaylist();
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
              ),

              child: Text(
                "Play",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    for (var item in playlists) {
      item.controller.dispose();
    }

    urlController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06152B),

      appBar: AppBar(
        backgroundColor: const Color(0xff06152B),
        elevation: 0,

        title: Text(
          "Playlists",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),

        actions: const [
          Icon(
            Icons.notifications_none,
            color: Colors.white,
          ),

          SizedBox(width: 14),

          Icon(
            Icons.star_border,
            color: Colors.white,
          ),

          SizedBox(width: 14),

          Icon(
            Icons.search,
            color: Colors.white,
          ),

          SizedBox(width: 14),
        ],
      ),

      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : playlists.isEmpty
              ? Center(
                  child: Text(
                    "No Playlists Found",
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : GridView.builder(
                  padding:
                      const EdgeInsets.all(12),

                  itemCount: playlists.length,

                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.65,
                  ),

                  itemBuilder: (context, index) {
                    final item =
                        playlists[index];

                    return Container(
                      decoration: BoxDecoration(
                        color:
                            const Color(0xff111827),

                        borderRadius:
                            BorderRadius.circular(
                                14),

                        border: Border.all(
                          color: Colors.white10,
                        ),
                      ),

                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius
                                      .vertical(
                                top:
                                    Radius.circular(
                                        14),
                              ),

                              child: AspectRatio(
                                aspectRatio: 16 / 9,

                                child: VideoPlayer(
                                  item.controller,
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding:
                                const EdgeInsets.all(
                                    12),

                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.url,

                                    maxLines: 1,

                                    overflow:
                                        TextOverflow
                                            .ellipsis,

                                    style:
                                        GoogleFonts
                                            .poppins(
                                      color: Colors
                                          .white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),

                                IconButton(
                                  onPressed: () {
                                    if (item
                                        .controller
                                        .value
                                        .isPlaying) {
                                      item.controller
                                          .pause();
                                    } else {
                                      item.controller
                                          .play();
                                    }

                                    setState(() {});
                                  },

                                  icon: Icon(
                                    item.controller
                                            .value
                                            .isPlaying
                                        ? Icons.pause
                                        : Icons
                                            .play_arrow,

                                    color:
                                        Colors.white,
                                  ),
                                ),

                                IconButton(
                                  onPressed: () {
                                    item.controller
                                        .dispose();

                                    playlists
                                        .removeAt(
                                            index);

                                    setState(() {});
                                  },

                                  icon: const Icon(
                                    Icons.delete,
                                    color:
                                        Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

      floatingActionButton:
          FloatingActionButton(
        backgroundColor: Colors.cyan,

        onPressed:
            showAddPlaylistDialog,

        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}