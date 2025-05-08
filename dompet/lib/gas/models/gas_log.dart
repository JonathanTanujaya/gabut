import 'package:hive/hive.dart';

part 'gas_log.g.dart';

@HiveType(typeId: 1)
class GasLog {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final double distance;

  @HiveField(2)
  final double cost;

  @HiveField(3)
  final double kmPerLiter;
  
  @HiveField(4)
  final double odometer;
  
  @HiveField(5)
  final double volume;

  GasLog({
    required this.date,
    required this.distance,
    required this.cost,
    required this.kmPerLiter,
    required this.odometer,
    required this.volume,
  });
}



  @override
  void write(BinaryWriter writer, GasLog obj) {
    writer.write(obj.date.millisecondsSinceEpoch);
    writer.write(obj.distance);
    writer.write(obj.cost);
    writer.write(obj.kmPerLiter);
    writer.write(obj.odometer);
    writer.write(obj.volume);
  }
