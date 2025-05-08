import 'package:flutter/material.dart';
import 'package:try2/gas/models/gas_log.dart';
import 'package:try2/gas/utils/formatters.dart';

class StatsSummary extends StatelessWidget {
  final List<GasLog> logs;

  const StatsSummary({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    // Calculate statistics
    double totalDistance = 0;
    double totalCost = 0;
    double totalLiters = 0;
    double bestEfficiency = 0;
    double worstEfficiency = double.infinity;
    
    for (var log in logs) {
      totalDistance += log.distanceKm;
      totalCost += log.cost;
      totalLiters += log.fuelLiters;
      
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
              "Total Jarak Tempuh", 
              "${totalDistance.toStringAsFixed(1)} km"
            ),
            _buildStatRow(
              "Total Biaya Pengeluaran", 
              Formatters.currency.format(totalCost)
            ),
            _buildStatRow(
              "Total Bahan Bakar", 
              "${totalLiters.toStringAsFixed(2)} liter"
            ),
            _buildStatRow(
              "Rata-rata Efisiensi", 
              "${averageEfficiency.toStringAsFixed(2)} km/L"
            ),
            _buildStatRow(
              "Efisiensi Terbaik", 
              "${bestEfficiency.toStringAsFixed(2)} km/L"
            ),
            _buildStatRow(
              "Efisiensi Terburuk", 
              "${worstEfficiency.toStringAsFixed(2)} km/L"
            ),
            _buildStatRow(
              "Biaya per Kilometer", 
              "${Formatters.currency.format(averageCostPerKm)}/km"
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }
}