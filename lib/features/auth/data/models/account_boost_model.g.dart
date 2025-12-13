// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_boost_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountBoostModelAdapter extends TypeAdapter<AccountBoostModel> {
  @override
  final int typeId = 8;

  @override
  AccountBoostModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccountBoostModel(
      activeKey: fields[0] as String,
      type: fields[1] as AccountBoostType,
      multiplier: fields[2] as int,
      totalAmount: fields[3] as int,
      remainingAmount: fields[4] as int,
      activatedAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AccountBoostModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.activeKey)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.multiplier)
      ..writeByte(3)
      ..write(obj.totalAmount)
      ..writeByte(4)
      ..write(obj.remainingAmount)
      ..writeByte(5)
      ..write(obj.activatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountBoostModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AccountBoostTypeAdapter extends TypeAdapter<AccountBoostType> {
  @override
  final int typeId = 7;

  @override
  AccountBoostType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AccountBoostType.minutes;
      case 1:
        return AccountBoostType.stages;
      default:
        return AccountBoostType.minutes;
    }
  }

  @override
  void write(BinaryWriter writer, AccountBoostType obj) {
    switch (obj) {
      case AccountBoostType.minutes:
        writer.writeByte(0);
        break;
      case AccountBoostType.stages:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountBoostTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
