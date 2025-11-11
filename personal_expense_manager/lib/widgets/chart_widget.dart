import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/format_currency.dart';

class ExpensePieChart extends StatelessWidget {
  final Map<String, double> categoryExpenses;

  const ExpensePieChart({super.key, required this.categoryExpenses});

  @override
  Widget build(BuildContext context) {
    if (categoryExpenses.isEmpty) {
      return const Center(
        child: Text('Chưa có dữ liệu chi tiêu'),
      );
    }

    final total = categoryExpenses.values.fold(0.0, (sum, val) => sum + val);
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
    ];

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: categoryExpenses.entries.toList().asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value;
                final percentage = (data.value / total * 100);
                return PieChartSectionData(
                  color: colors[index % colors.length],
                  value: data.value,
                  title: '${percentage.toStringAsFixed(1)}%',
                  radius: 80,
                  titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: categoryExpenses.entries.toList().asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  color: colors[index % colors.length],
                ),
                const SizedBox(width: 8),
                Text('${data.key}: ${CurrencyFormatter.format(data.value)}'),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

class MonthlyBarChart extends StatelessWidget {
  final Map<String, double> monthlyExpenses;

  const MonthlyBarChart({super.key, required this.monthlyExpenses});

  @override
  Widget build(BuildContext context) {
    if (monthlyExpenses.isEmpty) {
      return const Center(
        child: Text('Chưa có dữ liệu chi tiêu'),
      );
    }

    final sortedEntries = monthlyExpenses.entries.toList()
      ..sort((a, b) {
        final partsA = a.key.split('/');
        final partsB = b.key.split('/');
        final dateA = DateTime(int.parse(partsA[1]), int.parse(partsA[0]));
        final dateB = DateTime(int.parse(partsB[1]), int.parse(partsB[0]));
        return dateA.compareTo(dateB);
      });

    final maxY = sortedEntries.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return Column(
      children: [
        SizedBox(
          height: 300,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY * 1.2,
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      CurrencyFormatter.format(rod.toY),
                      const TextStyle(color: Colors.white),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 && value.toInt() < sortedEntries.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            sortedEntries[value.toInt()].key,
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 60,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${(value / 1000000).toStringAsFixed(1)}M',
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: sortedEntries.asMap().entries.map((entry) {
                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value.value,
                      color: Colors.blue,
                      width: 20,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
