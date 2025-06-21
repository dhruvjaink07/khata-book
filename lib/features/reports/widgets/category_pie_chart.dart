import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryPieChart extends StatelessWidget {
  final List<double> values;
  final List<Color> colors;
  final List<String> labels; // <-- Add this
  final double radius;
  final double centerSpaceRadius;
  final String title;
  const CategoryPieChart({
    super.key,
    required this.title,
    required this.values,
    required this.colors,
    required this.labels, // <-- Add this
    this.radius = 25,
    this.centerSpaceRadius = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Center(
          child: SizedBox(
            width: 180,
            height: 180,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(enabled: true),
                sections: List.generate(values.length, (i) {
                  return PieChartSectionData(
                    color: colors[i % colors.length],
                    value: values[i],
                    radius: radius,
                    showTitle: false,
                  );
                }),
                centerSpaceRadius: centerSpaceRadius,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Add a simple legend
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: List.generate(labels.length, (i) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colors[i % colors.length],
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 4),
                Text(labels[i], style: GoogleFonts.inter(fontSize: 12)),
              ],
            );
          }),
        ),
      ],
    );
  }
}
