// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translate_category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TranslateCategoryAdapter extends TypeAdapter<TranslateCategory> {
  @override
  final int typeId = 8;

  @override
  TranslateCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TranslateCategory(
      category: fields[0] as String?,
      language: fields[1] as Language?,
    );
  }

  @override
  void write(BinaryWriter writer, TranslateCategory obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.category)
      ..writeByte(1)
      ..write(obj.language);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranslateCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
