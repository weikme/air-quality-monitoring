// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_of_city_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ListOfCityModelsAdapter extends TypeAdapter<ListOfCityModels> {
  @override
  final int typeId = 1;

  @override
  ListOfCityModels read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ListOfCityModels(
      listOfCityModels: (fields[0] as List?)?.cast<CityModel?>(),
      city: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ListOfCityModels obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.listOfCityModels)
      ..writeByte(1)
      ..write(obj.city);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListOfCityModelsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
