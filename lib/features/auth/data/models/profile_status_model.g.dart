// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_status_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileStatusModelAdapter extends TypeAdapter<ProfileStatusModel> {
  @override
  final int typeId = 1;

  @override
  ProfileStatusModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileStatusModel(
      language: fields[0] as AppLanguage,
      level: fields[1] as int,
      progress: fields[2] as double,
      stage: fields[3] as int,
      wordsModel: fields[4] as WordsModel,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileStatusModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.language)
      ..writeByte(1)
      ..write(obj.level)
      ..writeByte(2)
      ..write(obj.progress)
      ..writeByte(3)
      ..write(obj.stage)
      ..writeByte(4)
      ..write(obj.wordsModel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileStatusModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
