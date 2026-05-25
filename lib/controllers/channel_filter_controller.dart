import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:spozfy/models/channel_model.dart';

class ChannelsFilterController extends GetxController {

  final int categoryId;

  ChannelsFilterController(this.categoryId);

  var isLoading = false.obs;

  var channels = <ChannelModel>[].obs;

  final Dio dio = Dio();

  @override
  void onInit() {
    super.onInit();
    fetchChannels();
  }

  Future<void> fetchChannels() async {

    try {

      isLoading.value = true;

      final baseUrl = dotenv.env['FIBER_BASE_URL'];

      final response = await dio.get(
        '$baseUrl/categories/$categoryId/channels',
      );

      if (response.statusCode == 200) {

        final List data = response.data['data'];

        channels.value = data
            .map((e) => ChannelModel.fromJson(e))
            .toList();
      }

    } catch (e) {

      debugPrint(e as String?);

    } finally {

      isLoading.value = false;
    }
  }
}