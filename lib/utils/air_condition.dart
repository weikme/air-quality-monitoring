import 'dart:developer';

import 'package:air_quality/air_quality.dart';
import 'package:collection/collection.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
import '../hive_models/city_model.dart';
import '../hive_models/list_of_city_models.dart';

class AirCondition {
  static const String _airToken = 'd91a535bb537fadd1d379df5ecf52bf64e6e263a';

  List<String> cities = [
    'Cherkasy',
    'Chernihiv',
    'Chernivtsi',
    'Dnipro',
    'Donetsk',
    'Ivano-Frankivsk',
    'Kharkiv',
    'Kherson',
    'Khmelnytskyi',
    'Kyiv',
    'Kropyvnytskyi',
    'Luhansk',
    'Lviv',
    'Mykolaiv',
    'Odessa',
    'Poltava',
    'Rivne',
    'Sumy',
    'Ternopil',
    'Vinnytsia',
    'Lutsk',
    'Uzhhorod',
    'Zaporizhzhia',
    'Zhytomyr',
  ];

  Future<CityModel?> getAirQualityFromIp() async {
    AirQualityData? airQualityFromIp;
    DateTime currentTime = DateTime.now();

    CityModel cityModel;
    try {
      airQualityFromIp = await AirQuality(_airToken).feedFromIP();
      cityModel = CityModel(
        dateTime: currentTime,
        airQualityLevel: airQualityFromIp.airQualityLevel.toString(),
        airQualityIndex: airQualityFromIp.airQualityIndex.toString(),
      );
      log('${cityModel.airQualityIndex}');
      log('${cityModel.airQualityLevel}');
    } catch (e) {
      rethrow;
    }

    return cityModel;
  }

  Future<AirQualityData?> _getAirCityData({required String city}) async {
    try {
      return await AirQuality(_airToken).feedFromCity(city);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<ListOfCityModels>?> getAirQualityFromCity(
      {bool isForceReloaded = false}) async {
    final DateTime currentTime = DateTime.now();

    try {
      final openedCheckBox =
          await Hive.openBox<ListOfCityModels>(airQualityDataBox);
      if (openedCheckBox.isEmpty) {
        return fetchCityData();
      } else {
        for (final city in cities) {
          final listOfCityModels = openedCheckBox.get(city);
          if (listOfCityModels != null) {
            final CityModel? lastFetchedModel = listOfCityModels
                .listOfCityModels
                .firstWhereOrNull((element) => element?.dateTime != null);
            final DateTime lastFetchedTime =
                lastFetchedModel?.dateTime ?? DateTime.now();
            final Duration difference = currentTime.difference(lastFetchedTime);
            if (difference.inDays > 5) {
              return fetchCityData();
            } else if (isForceReloaded && difference.inDays > 2) {
              return fetchCityData();
            } else {
              return fetchLocal();
            }
          }
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<ListOfCityModels>> fetchLocal() async {
    List<ListOfCityModels> listOfCityModel = [];
    final openedCheckBox =
        await Hive.openBox<ListOfCityModels>(airQualityDataBox);
    for (String city in cities) {
      log(city);
      final model = openedCheckBox.get(city);
      if (model == null) {
        continue;
      } else {
        listOfCityModel.add(model);
      }
    }
    return listOfCityModel;
  }

  Future<ListOfCityModels?> fetchOneCity({required String city}) async {
    try {
      final openedCheckBox =
          await Hive.openBox<ListOfCityModels>(airQualityDataBox);
      final DateTime currentTime = DateTime.now();

      final airQualityData = await _getAirCityData(city: city);
      if (airQualityData != null) {
        final ListOfCityModels cityList = openedCheckBox.get(
          city,
          defaultValue: ListOfCityModels(city: city),
        )!;
        final cityModel = CityModel(
          airQualityIndex: airQualityData.airQualityIndex.toString(),
          airQualityLevel: airQualityData.airQualityLevel.toString(),
          dateTime: currentTime,
        );
        cityList.listOfCityModels.add(cityModel);
        openedCheckBox.put(city, cityList);
        return cityList;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<ListOfCityModels>> fetchCityData() async {
    List<ListOfCityModels> listOfCityModel = [];
    for (String city in cities) {
      log(city);
      final model = await fetchOneCity(city: city);
      if (model == null) {
        continue;
      } else {
        listOfCityModel.add(model);
      }
    }
    return listOfCityModel;
  }
}
