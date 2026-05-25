import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spozfy/components/comments/comments_section.dart';
import 'package:spozfy/controllers/channels_play_controller.dart';
import 'package:video_player/video_player.dart';

class ChannelPlayScreen extends StatefulWidget {
  final int id;

  const ChannelPlayScreen({
    super.key,
    required this.id,
  });

  @override
  State<ChannelPlayScreen> createState() =>
      _ChannelPlayScreenState();
}

class _ChannelPlayScreenState
    extends State<ChannelPlayScreen> {
  late final ChannelPlayController c;

  late final String _tag =
      'channel_${widget.id}';

  @override
  void initState() {
    super.initState();

    c = Get.put(
      ChannelPlayController(widget.id),
      tag: _tag,
    );
  }

  @override
  void dispose() {
    Get.delete<ChannelPlayController>(
      tag: _tag,
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Obx(() {

        if (c.isLoading.value &&
            !c.isInitialized.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }

        if (c.error.isNotEmpty &&
            !c.isInitialized.value) {
          return _ErrorView(
            message: c.error.value,
            onRetry: c.retry,
          );
        }

        if (c.isFullScreen.value) {
          return _PlayerView(
            c: c,
            fullScreen: true,
          );
        }

        return SafeArea(
          child: ListView(
            children: [

              _PlayerView(
                c: c,
                fullScreen: false,
              ),

              _ChannelInfo(c: c),

              CommentsSection(
                channelId: widget.id,
              ),

              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }
}

class _PlayerView extends StatelessWidget {
  final ChannelPlayController c;
  final bool fullScreen;

  const _PlayerView({
    required this.c,
    required this.fullScreen,
  });

  @override
  Widget build(BuildContext context) {
    final player = Obx(() {

      if (!c.isInitialized.value ||
          c.video == null) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      }

      return GestureDetector(
        onTap: c.toggleControls,

        behavior: HitTestBehavior.opaque,

        child: Stack(
          alignment: Alignment.center,

          children: [

            Center(
              child: AspectRatio(
                aspectRatio:
                    c.video!.value.aspectRatio,

                child: VideoPlayer(c.video!),
              ),
            ),

            if (c.isBuffering.value &&
                c.isPlaying.value)
              const CircularProgressIndicator(
                color: Colors.white,
              ),

            _ControlsOverlay(c: c),
          ],
        ),
      );
    });

    if (fullScreen) {
      return SizedBox.expand(
        child: ColoredBox(
          color: Colors.black,
          child: player,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 16 / 9,

      child: ColoredBox(
        color: Colors.black,
        child: player,
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  final ChannelPlayController c;

  const _ControlsOverlay({
    required this.c,
  });

  String _fmt(Duration d) {

    String two(int n) =>
        n.toString().padLeft(2, '0');

    final h = d.inHours;

    final m =
        d.inMinutes.remainder(60);

    final s =
        d.inSeconds.remainder(60);

    return h > 0
        ? '${two(h)}:${two(m)}:${two(s)}'
        : '${two(m)}:${two(s)}';
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFE53935);

    return Obx(() {

      final visible =
          c.controlsVisible.value;

      final live = c.isLive;

      final dur = c.duration.value
          .inMilliseconds
          .toDouble();

      final pos = c.position.value
          .inMilliseconds
          .toDouble()
          .clamp(
            0,
            dur <= 0 ? 1 : dur,
          );

      final buf = dur <= 0
          ? 0.0
          : (c.buffered.value
                      .inMilliseconds /
                  dur)
              .clamp(0.0, 1.0);

      return IgnorePointer(
        ignoring: !visible,

        child: AnimatedOpacity(
          opacity: visible ? 1 : 0,

          duration:
              const Duration(milliseconds: 250),

          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,

                colors: [
                  Colors.black54,
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black87,
                ],

                stops: [
                  0,
                  0.25,
                  0.65,
                  1,
                ],
              ),
            ),

            child: Column(
              children: [

                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(
                    4,
                    4,
                    12,
                    0,
                  ),

                  child: Row(
                    children: [

                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),

                        onPressed: () {

                          if (c.isFullScreen.value) {
                            c.toggleFullScreen();
                          } else {
                            Get.back();
                          }
                        },
                      ),

                      Expanded(
                        child: Text(
                          c.channel.value?.name ??
                              '',

                          maxLines: 1,

                          overflow:
                              TextOverflow.ellipsis,

                          style: GoogleFonts.acme(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),

                      if (live)
                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),

                          decoration: BoxDecoration(
                            color: accent,

                            borderRadius:
                                BorderRadius.circular(
                              4,
                            ),
                          ),

                          child: Text(
                            'LIVE',

                            style:
                                GoogleFonts.acme(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const Spacer(),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [

                    if (!live)
                      _CircleBtn(
                        icon: Icons.replay_10,
                        size: 30,
                        onTap: () =>
                            c.seekRelative(-10),
                      ),

                    const SizedBox(width: 28),

                    _CircleBtn(
                      icon: c.isPlaying.value
                          ? Icons.pause
                          : Icons.play_arrow,

                      size: 46,

                      onTap: c.togglePlay,
                    ),

                    const SizedBox(width: 28),

                    if (!live)
                      _CircleBtn(
                        icon: Icons.forward_10,
                        size: 30,
                        onTap: () =>
                            c.seekRelative(10),
                      ),
                  ],
                ),

                const Spacer(),

                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(
                    12,
                    0,
                    8,
                    6,
                  ),

                  child: Row(
                    children: [

                      if (!live) ...[

                        Text(
                          _fmt(c.position.value),

                          style:
                              GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),

                        Expanded(
                          child: SizedBox(
                            height: 28,

                            child: Stack(
                              alignment:
                                  Alignment.center,

                              children: [

                                Container(
                                  height: 3,
                                  color:
                                      Colors.white24,
                                ),

                                FractionallySizedBox(
                                  alignment:
                                      Alignment
                                          .centerLeft,

                                  widthFactor: buf,

                                  child: Container(
                                    height: 3,
                                    color:
                                        Colors.white38,
                                  ),
                                ),

                                SliderTheme(
                                  data:
                                      SliderThemeData(
                                    trackHeight: 3,
                                    activeTrackColor:
                                        accent,
                                    inactiveTrackColor:
                                        Colors
                                            .transparent,
                                    thumbColor:
                                        accent,
                                    overlayColor: accent
                                        .withOpacity(
                                            0.2),

                                    thumbShape:
                                        const RoundSliderThumbShape(
                                      enabledThumbRadius:
                                          6,
                                    ),

                                    overlayShape:
                                        const RoundSliderOverlayShape(
                                      overlayRadius:
                                          14,
                                    ),
                                  ),

                                  child: Slider(
                                    min: 0,

                                    max: dur <= 0
                                        ? 1
                                        : dur,

                                    value:
                                        pos.toDouble(),

                                    onChanged: (v) {
                                      c.seekTo(
                                        Duration(
                                          milliseconds:
                                              v.toInt(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Text(
                          _fmt(c.duration.value),

                          style:
                              GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ] else
                        const Spacer(),

                      IconButton(
                        icon: Icon(
                          c.isFullScreen.value
                              ? Icons
                                  .fullscreen_exit
                              : Icons.fullscreen,

                          color: Colors.white,
                        ),

                        onPressed:
                            c.toggleFullScreen,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback onTap;

  const _CircleBtn({
    required this.icon,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.all(8),

        decoration: const BoxDecoration(
          color: Colors.black38,
          shape: BoxShape.circle,
        ),

        child: Icon(
          icon,
          color: Colors.white,
          size: size,
        ),
      ),
    );
  }
}

class _ChannelInfo extends StatelessWidget {
  final ChannelPlayController c;

  const _ChannelInfo({
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {

      final ch = c.channel.value;

      if (ch == null) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.all(16),

        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            ClipRRect(
              borderRadius:
                  BorderRadius.circular(10),

              child: ch.image.isEmpty
                  ? Container(
                      width: 56,
                      height: 56,
                      color: Colors.white12,

                      child: const Icon(
                        Icons.tv,
                        color: Colors.white54,
                      ),
                    )
                  : Image.network(
                      ch.image,

                      width: 56,
                      height: 56,

                      fit: BoxFit.cover,

                      errorBuilder:
                          (_, __, ___) {
                        return Container(
                          width: 56,
                          height: 56,
                          color: Colors.white12,

                          child: const Icon(
                            Icons.tv,
                            color: Colors.white54,
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    ch.name,

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white12,

                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),

                    child: Text(
                      ch.category,

                      style:
                          GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [

            const Icon(
              Icons.error_outline,
              color: Colors.white54,
              size: 48,
            ),

            const SizedBox(height: 12),

            Text(
              message,
              textAlign: TextAlign.center,

              style: GoogleFonts.poppins(
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: onRetry,

              icon: const Icon(Icons.refresh),

              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}