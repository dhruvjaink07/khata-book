import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DailyBarChart extends StatelessWidget {
  final String title;
  final List<double> values;
  final List<String> xLabels;
  final double maxY;
  final double interval;
  final Color barColor;

  const DailyBarChart({
    Key? key,
    required this.title,
    required this.values,
    required this.xLabels,
    required this.maxY,
    required this.interval,
    this.barColor = const Color(0xFF6B4EFF),
  }) : super(key: key);

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
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              minY: 0,
              maxY: maxY,
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                horizontalInterval: interval,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey.shade300,
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
                drawVerticalLine: false,
              ),
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  left: BorderSide(color: Color(0xFFEEEEEE), width: 1),
                  bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
                  top: BorderSide.none,
                  right: BorderSide.none,
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 48,
                    interval: interval,
                    getTitlesWidget: (value, meta) {
                      if (value % interval != 0) return const SizedBox.shrink();
                      String label;
                      if (value == 0) {
                        label = '₹0k';
                      } else if (value == maxY) {
                        label = '₹${(maxY / 1000).toStringAsFixed(0)}k';
                      } else {
                        label = '${(value / 1000).toStringAsFixed(1)}k';
                      }
                      return Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      if (value.toInt() < 0 ||
                          value.toInt() >= xLabels.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          xLabels[value.toInt()],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              barGroups: List.generate(values.length, (i) {
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: values[i],
                      color: barColor.withOpacity(0.18),
                      width: 24,
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ],
                );
              }),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => Colors.white,
                  tooltipBorderRadius: BorderRadius.circular(12),
                  tooltipPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  tooltipMargin: 8,
                  tooltipBorder: BorderSide(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '₹${rod.toY.toInt()}',
                      TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    );
                  },
                  fitInsideVertically: true,
                  fitInsideHorizontally: true,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
