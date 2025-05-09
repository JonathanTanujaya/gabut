import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:try2/gas/models/gas_log.dart';
import 'package:try2/gas/utils/formatters.dart';

class EfficiencyChart extends StatelessWidget {
  final List<GasLog> logs;

  const EfficiencyChart({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: LineChart(_efficiencyData()),
      ),
    );
  }

  LineChartData _efficiencyData() {
    final spots = logs
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.kmPerLiter))
        .toList();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: _calculateGridInterval(_getMaxEfficiency()),
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
            interval: _calculateGridInterval(_getMaxEfficiency()),
            getTitlesWidget: (value, meta) => Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                value.toStringAsFixed(1),
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
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          color: Colors.green[700],
          barWidth: 2.5,
          shadow: Shadow(
            color: Colors.green[100]!,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          belowBarData: BarAreaData(
            show: true,
            color: Colors.transparent, // Ubah dari Colors.green[50]! menjadi transparan
          ),
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) =>
                FlDotCirclePainter(
              radius: 3,
              color: Colors.green[700]!,
              strokeWidth: 1.5,
              strokeColor: Colors.white,
            ),
          ),
          preventCurveOverShooting: true,
        ),
      ],
      minY: 0,
      maxY: _getMaxEfficiency().ceilToDouble() + 3,
    );
  }

  double _calculateGridInterval(double maxValue) {
    if (maxValue < 10) return 2;
    if (maxValue < 20) return 5;
    return 10;
  }

  double _calculateLabelInterval(int itemCount) {
    if (itemCount <= 5) return 1;
    if (itemCount <= 10) return 2;
    return (itemCount / 4).ceilToDouble();
  }

  double _getMaxEfficiency() {
    return logs.fold(0, (prev, log) => log.kmPerLiter > prev ? log.kmPerLiter : prev);
  }
}
