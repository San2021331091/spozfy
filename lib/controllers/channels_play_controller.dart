import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:spozfy/models/channel_model.dart';
import 'package:video_player/video_player.dart';



class ChannelPlayController extends GetxController {
  final int channelId;
  ChannelPlayController(this.channelId);

  final Dio _dio = Dio();
  VideoPlayerController? video;

  final Rxn<ChannelModel> channel = Rxn<ChannelModel>();
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;

  final RxBool isInitialized = false.obs;
  final RxBool isPlaying = false.obs;
  final RxBool isBuffering = false.obs;
  final RxBool controlsVisible = true.obs;
  final RxBool isFullScreen = false.obs;

  final Rx<Duration> position = Duration.zero.obs;
  final Rx<Duration> duration = Duration.zero.obs;
  final Rx<Duration> buffered = Duration.zero.obs;

  // A channel reporting no real duration is treated as a live stream.
  bool get isLive => duration.value.inSeconds <= 0;

  Timer? _hideTimer;

  @override
  void onInit() {
    super.onInit();
    fetchChannel();
  }

  Future<void> fetchChannel() async {
    try {
      isLoading.value = true;
      error.value = '';

      final base = dotenv.env['FIBER_BASE_URL'];
      if (base == null || base.isEmpty) {
        throw 'FIBER_BASE_URL is not set in .env';
      }

      final res = await _dio.get(
        '$base/channels/$channelId',
        options: Options(
          // Don't throw on non-2xx; we handle the status ourselves below.
          validateStatus: (_) => true,
          responseType: ResponseType.json,
        ),
      );

      if (res.statusCode != 200) {
        throw 'Failed to load channel (${res.statusCode})';
      }

      // Dio already decodes JSON into a Map/List.
      final body = res.data;
      final data = (body is Map && body.containsKey('data')) ? body['data'] : body;
      channel.value = ChannelModel.fromJson(Map<String, dynamic>.from(data));

      await _setupPlayer(channel.value!.link);
    } on DioException catch (e) {
      error.value = e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout
          ? 'Connection timed out'
          : (e.message ?? 'Network error');
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _setupPlayer(String url) async {
    video = VideoPlayerController.networkUrl(
      Uri.parse(url),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: false),
    )..addListener(_listener);

    await video!.initialize();
    isInitialized.value = true;
    duration.value = video!.value.duration;
    await video!.play();
    _startHideTimer();
  }

  void _listener() {
    final v = video?.value;
    if (v == null) return;
    isPlaying.value = v.isPlaying;
    isBuffering.value = v.isBuffering;
    position.value = v.position;
    duration.value = v.duration;
    buffered.value = v.buffered.isNotEmpty ? v.buffered.last.end : Duration.zero;
    if (v.hasError) error.value = v.errorDescription ?? 'Playback error';
  }

  void togglePlay() {
    final v = video;
    if (v == null) return;
    v.value.isPlaying ? v.pause() : v.play();
    _startHideTimer();
  }

  void seekRelative(int seconds) {
    if (video == null || isLive) return;
    video!.seekTo(position.value + Duration(seconds: seconds));
    _startHideTimer();
  }

  void seekTo(Duration d) {
    video?.seekTo(d);
    _startHideTimer();
  }

  void toggleControls() {
    controlsVisible.value = !controlsVisible.value;
    if (controlsVisible.value) _startHideTimer();
  }

  void _startHideTimer() {
    controlsVisible.value = true;
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 4), () {
      if (isPlaying.value) controlsVisible.value = false;
    });
  }

  Future<void> toggleFullScreen() async {
    isFullScreen.value = !isFullScreen.value;
    if (isFullScreen.value) {
      await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
      );
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    _startHideTimer();
  }

  void retry() {
    isInitialized.value = false;
    video?.removeListener(_listener);
    video?.dispose();
    video = null;
    fetchChannel();
  }

  @override
  void onClose() {
    _hideTimer?.cancel();
    video?.removeListener(_listener);
    video?.dispose();
    _dio.close();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.onClose();
  }
}