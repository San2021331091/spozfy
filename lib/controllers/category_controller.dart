import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:spozfy/models/category_model.dart';

class CategoryController extends GetxController {

  var isLoading = false.obs;

  var categories = <CategoryModel>[].obs;

  final Dio dio = Dio();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {

    try {

      isLoading.value = true;

      final baseUrl = dotenv.env['FIBER_BASE_URL'];

      final response = await dio.get(
        '$baseUrl/categories',
      );

      if (response.statusCode == 200) {

        final List data = response.data['data'];

        categories.value = data
            .map((e) => CategoryModel.fromJson(e))
            .toList();
      }

    } catch (e) {

      print(e);

    } finally {

      isLoading.value = false;
    }
  }
}