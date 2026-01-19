// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String,
      username: fields[1] as String?,
      email: fields[2] as String?,
      points: fields[3] as int,
      progressByLanguage:
          (fields[4] as Map).cast<AppLanguage, ProfileStatusModel>(),
      currentStage: fields[5] as CurrentStage?,
      lastSyncedAt: fields[6] as DateTime?,
      joinedAt: fields[8] as DateTime,
      isGuest: fields[7] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.points)
      ..writeByte(4)
      ..write(obj.progressByLanguage)
      ..writeByte(5)
      ..write(obj.currentStage)
      ..writeByte(6)
      ..write(obj.lastSyncedAt)
      ..writeByte(7)
      ..write(obj.isGuest)
      ..writeByte(8)
      ..write(obj.joinedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
