import 'package:flutter/material.dart';
import 'package:try2/gas/models/gas_log.dart';
import 'package:try2/gas/utils/formatters.dart';

class StatsSummary extends StatelessWidget {
  final List<GasLog> logs;

  const StatsSummary({super.key, required this.logs});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Calculate statistics
    double totalDistance = 0;
    double totalCost = 0;
    double totalLiters = 0;
    double bestEfficiency = 0;
    double worstEfficiency = double.infinity;
    
    for (var log in logs) {
      totalDistance += log.distance;
      totalCost += log.cost;
      totalLiters += log.volume;
      
      if (log.kmPerLiter > bestEfficiency) {
        bestEfficiency = log.kmPerLiter;
      }
      
      if (log.kmPerLiter < worstEfficiency) {
        worstEfficiency = log.kmPerLiter;
      }
    }
    
    double averageEfficiency = totalDistance / totalLiters;
    double averageCostPerKm = totalCost / totalDistance;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatRow(
              theme,
              "Total Jarak Tempuh", 
              "${totalDistance.toStringAsFixed(1)} km"
            ),
            _buildStatRow(
              theme,
              "Total Biaya Pengeluaran", 
              Formatters.currency.format(totalCost)
            ),
            _buildStatRow(
              theme,
              "Total Bahan Bakar", 
              "${totalLiters.toStringAsFixed(2)} liter"
            ),
            _buildStatRow(
              theme,
              "Rata-rata Efisiensi", 
              "${averageEfficiency.toStringAsFixed(2)} km/L"
            ),
            _buildStatRow(
              theme,
              "Efisiensi Terbaik", 
              "${bestEfficiency.toStringAsFixed(2)} km/L"
            ),
            _buildStatRow(
              theme,
              "Efisiensi Terburuk", 
              "${worstEfficiency.toStringAsFixed(2)} km/L"
            ),
            _buildStatRow(
              theme,
              "Biaya per Kilometer", 
              "${Formatters.currency.format(averageCostPerKm)}/km"
            ),
          ],
        ),
      ),
    );
  }  Widget _buildStatRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}