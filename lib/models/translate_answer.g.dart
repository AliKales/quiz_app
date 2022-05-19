// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translate_answer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TranslateAnswerAdapter extends TypeAdapter<TranslateAnswer> {
  @override
  final int typeId = 5;

  @override
  TranslateAnswer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TranslateAnswer(
      language: fields[0] as Language?,
      answers: (fields[1] as List?)?.cast<Answer>(),
    );
  }

  @override
  void write(BinaryWriter writer, TranslateAnswer obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.language)
      ..writeByte(1)
      ..write(obj.answers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranslateAnswerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
