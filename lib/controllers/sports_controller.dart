import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:spozfy/models/channel_model.dart';

class SportsController extends GetxController {
  final Dio dio = Dio();

  var isLoading = true.obs;

  var channels = <ChannelModel>[].obs;

  final String baseUrl = dotenv.env['FIBER_BASE_URL']!;

  @override
  void onInit() {
    fetchChannels();
    super.onInit();
  }

  Future<void> fetchChannels() async {
    try {
      isLoading.value = true;

      final response = await dio.get(
        "$baseUrl/channels",
      );

      final List data = response.data["data"];

      channels.value = data
          .map((e) => ChannelModel.fromJson(e))
          .toList();
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}