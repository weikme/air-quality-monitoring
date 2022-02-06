import 'package:hive/hive.dart';

part 'city_model.g.dart';

@HiveType(typeId: 0)
class CityModel {
  @HiveField(0)
  String? airQualityIndex;
  @HiveField(1)
  String? airQualityLevel;
  @HiveField(2)
  DateTime? dateTime;

  CityModel({
    this.airQualityLevel,
    this.airQualityIndex,
    this.dateTime,
  });
}
