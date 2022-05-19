// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'values.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DatabaseStatusAdapter extends TypeAdapter<DatabaseStatus> {
  @override
  final int typeId = 10;

  @override
  DatabaseStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DatabaseStatus.error;
      case 1:
        return DatabaseStatus.nulll;
      case 2:
        return DatabaseStatus.data;
      default:
        return DatabaseStatus.error;
    }
  }

  @override
  void write(BinaryWriter writer, DatabaseStatus obj) {
    switch (obj) {
      case DatabaseStatus.error:
        writer.writeByte(0);
        break;
      case DatabaseStatus.nulll:
        writer.writeByte(1);
        break;
      case DatabaseStatus.data:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DatabaseStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
