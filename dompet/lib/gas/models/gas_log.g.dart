// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gas_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GasLogAdapter extends TypeAdapter<GasLog> {
  @override
  final int typeId = 1;

  @override
  GasLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GasLog(
      date: fields[0] as DateTime,
      distance: fields[1] as double,
      cost: fields[2] as double,
      kmPerLiter: fields[3] as double,
      odometer: fields[4] as double,
      volume: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, GasLog obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.distance)
      ..writeByte(2)
      ..write(obj.cost)
      ..writeByte(3)
      ..write(obj.kmPerLiter)
      ..writeByte(4)
      ..write(obj.odometer)
      ..writeByte(5)
      ..write(obj.volume);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GasLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
