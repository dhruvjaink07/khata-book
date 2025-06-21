import 'package:flutter/material.dart';

class CategoryFilterChips extends StatefulWidget {
  final List<String> filters;
  final Function(String) onSelected;

  const CategoryFilterChips({
    required this.filters,
    required this.onSelected,
    super.key,
  });

  @override
  State<CategoryFilterChips> createState() => _CategoryFilterChipsState();
}

class _CategoryFilterChipsState extends State<CategoryFilterChips> {
  String selected = 'All';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: widget.filters.map((filter) {
          final isSelected = selected == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (_) {
                setState(() => selected = filter);
                widget.onSelected(filter);
              },
              selectedColor: Color(0xff0066FF),
              backgroundColor: Color(0xFFF1F1F1),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
          );
        }).toList(),
      ),
    );
  }
}
