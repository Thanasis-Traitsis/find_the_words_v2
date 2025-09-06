// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'words_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordsModelAdapter extends TypeAdapter<WordsModel> {
  @override
  final int typeId = 4;

  @override
  WordsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordsModel(
      words: (fields[0] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, WordsModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.words);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
