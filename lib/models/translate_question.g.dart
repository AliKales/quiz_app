// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translate_question.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TranslateQuestionAdapter extends TypeAdapter<TranslateQuestion> {
  @override
  final int typeId = 9;

  @override
  TranslateQuestion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TranslateQuestion(
      language: fields[0] as Language?,
      question: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TranslateQuestion obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.language)
      ..writeByte(1)
      ..write(obj.question);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranslateQuestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
