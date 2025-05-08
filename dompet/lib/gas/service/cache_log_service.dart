import '../models/gas_log.dart';

class GasLogCache {
  final List<GasLog> logs;
  final double totalDistance;
  final double totalCost;
  final double averageEfficiency;

  GasLogCache({
    required this.logs,
    required this.totalDistance,
    required this.totalCost,
    required this.averageEfficiency,
  });

  factory GasLogCache.fromLogs(List<GasLog> rawLogs) {
    final logs = rawLogs.reversed.toList(); // reverse agar paling baru di atas

    double totalDistance = 0;
    double totalCost = 0;
    double totalEfficiency = 0;

    for (final log in logs) {
      totalDistance += log.distance;
      totalCost += log.cost;
      totalEfficiency += log.kmPerLiter;
    }

    return GasLogCache(
      logs: logs,
      totalDistance: totalDistance,
      totalCost: totalCost,
      averageEfficiency: logs.isEmpty ? 0 : totalEfficiency / logs.length,
    );
  }
}
