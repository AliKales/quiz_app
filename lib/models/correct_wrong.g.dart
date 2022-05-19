// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'correct_wrong.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CorrectWrongAdapter extends TypeAdapter<CorrectWrong> {
  @override
  final int typeId = 11;

  @override
  CorrectWrong read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CorrectWrong(
      correct: fields[0] as int,
      wrong: fields[1] as int,
      questionsLength: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CorrectWrong obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.correct)
      ..writeByte(1)
      ..write(obj.wrong)
      ..writeByte(2)
      ..write(obj.questionsLength);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CorrectWrongAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
