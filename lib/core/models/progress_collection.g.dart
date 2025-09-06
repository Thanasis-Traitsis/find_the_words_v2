// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProgressCollectionAdapter extends TypeAdapter<ProgressCollection> {
  @override
  final int typeId = 3;

  @override
  ProgressCollection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProgressCollection(
      progressMap: (fields[0] as Map).cast<String, ProfileStatusModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProgressCollection obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.progressMap);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgressCollectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
