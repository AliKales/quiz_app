// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistic.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StatisticAdapter extends TypeAdapter<Statistic> {
  @override
  final int typeId = 2;

  @override
  Statistic read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Statistic(
      correctAnswers: fields[0] as int,
      wrongAnswers: fields[1] as int,
      totalQuestions: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Statistic obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.correctAnswers)
      ..writeByte(1)
      ..write(obj.wrongAnswers)
      ..writeByte(2)
      ..write(obj.totalQuestions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatisticAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
