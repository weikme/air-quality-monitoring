import 'package:hive/hive.dart';

import 'city_model.dart';

part 'list_of_city_models.g.dart';

@HiveType(typeId: 1)
class ListOfCityModels extends HiveObject {
  @HiveField(0)
  CityModel? listOfCityModels;

  ListOfCityModels({
    required listOfCityModels,
  });
}
