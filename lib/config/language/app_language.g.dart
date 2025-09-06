// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_language.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppLanguageAdapter extends TypeAdapter<AppLanguage> {
  @override
  final int typeId = 2;

  @override
  AppLanguage read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppLanguage.greek;
      case 1:
        return AppLanguage.english;
      default:
        return AppLanguage.greek;
    }
  }

  @override
  void write(BinaryWriter writer, AppLanguage obj) {
    switch (obj) {
      case AppLanguage.greek:
        writer.writeByte(0);
        break;
      case AppLanguage.english:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppLanguageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
