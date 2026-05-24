import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spozfy/controllers/filter_controller.dart';

class FilterBar extends StatelessWidget {
  FilterBar({super.key});

  final controller = Get.put(FilterController());

  final List<String> filters = const [
    "All",
    "Live",
    "Recent",
    "Upcoming",
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(() {
        return Row(
          children: filters.map((text) {
            final selected = controller.selectedFilter.value == text;

            return GestureDetector(
              onTap: () => controller.setFilter(text),
              child: _FilterButton(
                text: text,
                selected: selected,
              ),
            );
          }).toList(),
        );
      }),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String text;
  final bool selected;

  const _FilterButton({
    required this.text,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFF00E0B8)
            : const Color(0xFF132235),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected ? Colors.black : Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}