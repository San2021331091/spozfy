import 'package:get/get.dart';

class FilterController extends GetxController {
  var selectedFilter = "All".obs;

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }
}