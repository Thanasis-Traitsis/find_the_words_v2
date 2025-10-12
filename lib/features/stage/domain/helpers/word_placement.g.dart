// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_placement.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordPlacementAdapter extends TypeAdapter<WordPlacement> {
  @override
  final int typeId = 6;

  @override
  WordPlacement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordPlacement(
      word: fields[0] as String,
      positions: (fields[1] as List).cast<int>(),
      isHorizontal: fields[2] as bool,
      isUsed: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, WordPlacement obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.word)
      ..writeByte(1)
      ..write(obj.positions)
      ..writeByte(2)
      ..write(obj.isHorizontal)
      ..writeByte(3)
      ..write(obj.isUsed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordPlacementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
