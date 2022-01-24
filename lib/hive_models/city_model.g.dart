// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CityModelAdapter extends TypeAdapter<CityModel> {
  @override
  final int typeId = 0;

  @override
  CityModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CityModel(
      place: fields[0] as String?,
      airQualityLevel: fields[2] as String?,
      airQualityIndex: fields[1] as String?,
      dateTimeYear: fields[3] as String,
      dateTimeMonth: fields[4] as String,
      dateTimeDay: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CityModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.place)
      ..writeByte(1)
      ..write(obj.airQualityIndex)
      ..writeByte(2)
      ..write(obj.airQualityLevel)
      ..writeByte(3)
      ..write(obj.dateTimeYear)
      ..writeByte(4)
      ..write(obj.dateTimeMonth)
      ..writeByte(5)
      ..write(obj.dateTimeDay);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CityModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
