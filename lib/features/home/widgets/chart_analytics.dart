import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:khata/l10n/app_localizations.dart';

class ExpenseChart extends StatelessWidget {
  const ExpenseChart({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final chartSize = constraints.maxWidth * 0.4; // 40% width
        final legendSpacing = constraints.maxWidth * 0.05;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: chartSize,
              height: chartSize,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: chartSize * 0.25, // 25% of pie size
                  sections: _getSections(chartSize * 0.15), // dynamic radius
                ),
              ),
            ),
            SizedBox(width: legendSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LegendItem(
                    color: Colors.blue,
                    text: loc.housing,
                    percentage: '35%',
                  ),
                  LegendItem(
                    color: Colors.orange,
                    text: loc.food,
                    percentage: '25%',
                  ),
                  LegendItem(
                    color: Colors.green,
                    text: loc.transport,
                    percentage: '20%',
                  ),
                  LegendItem(
                    color: Colors.red,
                    text: loc.shopping,
                    percentage: '15%',
                  ),
                  LegendItem(
                    color: Colors.grey,
                    text: loc.others,
                    percentage: '5%',
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  List<PieChartSectionData> _getSections(double radius) {
    return [
      PieChartSectionData(
        color: Colors.blue,
        value: 35,
        title: '',
        radius: radius,
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: 25,
        title: '',
        radius: radius,
      ),
      PieChartSectionData(
        color: Colors.green,
        value: 20,
        title: '',
        radius: radius,
      ),
      PieChartSectionData(
        color: Colors.red,
        value: 15,
        title: '',
        radius: radius,
      ),
      PieChartSectionData(
        color: Colors.grey,
        value: 5,
        title: '',
        radius: radius,
      ),
    ];
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;
  final String percentage;

  const LegendItem({
    required this.color,
    required this.text,
    required this.percentage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
          Text(
            percentage,
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
