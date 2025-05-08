import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:try2/gas/service/gas_log_service.dart';
import '../widgets/stats_summary.dart';
import '../widgets/efficiency_chart.dart';
import '../widgets/cost_chart.dart';
import '../widgets/empty_state.dart';

class GasStatsScreen extends StatelessWidget {
  const GasStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gasService = Provider.of<GasLogService>(context);
    final cache = gasService.cache;

    final logs = cache.logs;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistik"),
      ),
      body: logs.isEmpty
          ? const EmptyState()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 StatsSummary(logs: logs),


                  const SizedBox(height: 20),
                  const Text(
                    "Efisiensi Konsumsi (km/L)",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  EfficiencyChart(
                    logs: logs.where((log) => log.kmPerLiter > 0).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Biaya Bensin (Rp)",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CostChart(
                    logs: logs.where((log) => log.cost > 0).toList(),
                  ),
                ],
              ),
            ),
    );
  }
}
