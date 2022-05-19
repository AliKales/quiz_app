// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_values.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameValuesAdapter extends TypeAdapter<GameValues> {
  @override
  final int typeId = 3;

  @override
  GameValues read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameValues(
      categories: (fields[0] as List?)?.cast<Category>(),
      questions: (fields[1] as List?)?.cast<Question>(),
      updateId: fields[2] as int?,
      databaseStatus: fields[3] as DatabaseStatus?,
      languages: (fields[4] as List?)?.cast<Language>(),
    );
  }

  @override
  void write(BinaryWriter writer, GameValues obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.categories)
      ..writeByte(1)
      ..write(obj.questions)
      ..writeByte(2)
      ..write(obj.updateId)
      ..writeByte(3)
      ..write(obj.databaseStatus)
      ..writeByte(4)
      ..write(obj.languages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameValuesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
