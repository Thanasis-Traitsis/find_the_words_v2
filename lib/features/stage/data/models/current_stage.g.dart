// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_stage.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrentStageAdapter extends TypeAdapter<CurrentStage> {
  @override
  final int typeId = 4;

  @override
  CurrentStage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrentStage(
      allWords: (fields[0] as List).cast<String>(),
      letters: (fields[1] as List).cast<String>(),
      board: (fields[2] as List).cast<String>(),
      placementTracker: fields[3] as WordPlacementTracker,
    );
  }

  @override
  void write(BinaryWriter writer, CurrentStage obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.allWords)
      ..writeByte(1)
      ..write(obj.letters)
      ..writeByte(2)
      ..write(obj.board)
      ..writeByte(3)
      ..write(obj.placementTracker);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentStageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
