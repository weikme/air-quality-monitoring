import 'package:hive/hive.dart';

part 'city_model.g.dart';

@HiveType(typeId: 0)
class CityModel extends HiveObject {
  @HiveField(0)
  String? place;
  @HiveField(1)
  String? airQualityIndex;
  @HiveField(2)
  String? airQualityLevel;
  @HiveField(3)
  String dateTimeYear;
  @HiveField(4)
  String dateTimeMonth;
  @HiveField(5)
  String dateTimeDay;

  CityModel({
    this.place,
    this.airQualityLevel,
    this.airQualityIndex,
    required this.dateTimeYear,
    required this.dateTimeMonth,
    required this.dateTimeDay,
  });
}
