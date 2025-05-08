import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'gas_log.g.dart';

@HiveType(typeId: 0)
class GasLog extends HiveObject {
  @HiveField(0)
  final DateTime date;
  
  @HiveField(1)
  final double distanceKm;
  
  @HiveField(2)
  final double cost;
  
  @HiveField(3)
  final double fuelLiters;
  
  @HiveField(4)
  final double kmPerLiter;

  GasLog({
    required this.date,
    required this.distanceKm,
    required this.cost,
    required this.fuelLiters,
    required this.kmPerLiter,
  });

  String formattedDate() {
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }
}