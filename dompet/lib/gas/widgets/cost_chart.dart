import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:try2/gas/models/gas_log.dart';
import 'package:try2/gas/utils/formatters.dart';

class CostChart extends StatelessWidget {
  final List<GasLog> logs;

  const CostChart({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: BarChart(_costData()),
      ),
    );
  }

  BarChartData _costData() {
    return BarChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: _calculateGridInterval(_getMaxCost()),
        getDrawingHorizontalLine: (value) => FlLine(
          color: Colors.grey[200],
          strokeWidth: 1,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          left: BorderSide(color: Colors.grey[400]!),
          bottom: BorderSide(color: Colors.grey[400]!),
        ),
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 20,
            interval: _calculateLabelInterval(logs.length),
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= logs.length) return const SizedBox();
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  Formatters.formatChartDate(logs[index].date),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: _calculateGridInterval(_getMaxCost()),
            getTitlesWidget: (value, meta) => Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                'Rp${Formatters.compactNumber.format(value)}',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        ),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      barGroups: List.generate(logs.length, (index) {
        return BarChartGroupData(
          x: index,
          barsSpace: 0.4,
          barRods: [
            BarChartRodData(
              toY: logs[index].cost,
              color: _getBarColor(logs[index].cost),
              width: 18,
              borderRadius: BorderRadius.circular(4),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                color: Colors.grey[100],
              ),
            ),
          ],
        );
      }),
      maxY: _getMaxCost() * 1.4,
    );
  }

  double _getMaxCost() {
    return logs.fold(0, (prev, log) => log.cost > prev ? log.cost : prev);
  }

  double _calculateGridInterval(double maxValue) {
    if (maxValue < 100000) return 25000;
    if (maxValue < 500000) return 100000;
    return 200000;
  }

  double _calculateLabelInterval(int itemCount) {
    if (itemCount <= 5) return 1;
    if (itemCount <= 10) return 2;
    return (itemCount / 4).ceilToDouble();
  }

  Color _getBarColor(double value) {
    final maxVal = _getMaxCost();
    return HSLColor.fromAHSL(1.0, 30, 0.8, 0.6 - (0.3 * (value / maxVal))).toColor();
  }
}
