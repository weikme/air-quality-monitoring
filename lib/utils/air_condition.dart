import 'dart:developer';

import 'package:air_quality/air_quality.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../hive_models/city_model.dart';

class AirCondition {
  // List<AirQualityData> _airQualityFromCityList = [];
  static const String airToken = 'd91a535bb537fadd1d379df5ecf52bf64e6e263a';

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

  CityModel cityModelDaytimeNow() {
    DateTime currentTime = DateTime.now();
    final cityModel = CityModel(
      dateTimeDay: currentTime.day.toString(),
      dateTimeMonth: currentTime.month.toString(),
      dateTimeYear: currentTime.year.toString(),
    );
    return cityModel;
  }

  Future<CityModel?> getAirQualityFromIp() async {
    AirQualityData? airQualityFromIp;
    DateTime currentTime = DateTime.now();

    CityModel cityModel;
    try {
      airQualityFromIp = await AirQuality(airToken).feedFromIP();
      cityModel = CityModel(
        dateTimeDay: currentTime.day.toString(),
        dateTimeMonth: currentTime.month.toString(),
        dateTimeYear: currentTime.year.toString(),
        place: airQualityFromIp.place,
        airQualityLevel: airQualityFromIp.airQualityLevel.toString(),
        airQualityIndex: airQualityFromIp.airQualityIndex.toString(),
      );
      log('${cityModel.place}');
      log('${cityModel.airQualityIndex}');
      log('${cityModel.airQualityLevel}');
    } catch (e) {
      rethrow;
    }
    if (cityModel.place != null) {
      return cityModel;
    }
  }

  Future<AirQualityData?> _getAirCityData({required String city}) async {
    try {
      return await AirQuality(airToken).feedFromCity(city);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<CityModel>?> getAirQualityFromCity(
      {bool isForceReloaded = false}) async {
    List<CityModel> listOfCityModel = [];
    DateTime currentTime = DateTime.now();

    try {
      final openedCheckBox = await Hive.openBox<CityModel>(cities.first);
      CityModel? checkBoxInfo = openedCheckBox.isNotEmpty
          ? CityModel(
              place: openedCheckBox.getAt(openedCheckBox.length - 1)?.place,
              airQualityIndex: openedCheckBox
                  .getAt(openedCheckBox.length - 1)
                  ?.airQualityIndex,
              airQualityLevel: openedCheckBox
                  .getAt(openedCheckBox.length - 1)
                  ?.airQualityLevel,
              dateTimeYear:
                  openedCheckBox.getAt(openedCheckBox.length - 1)!.dateTimeYear,
              dateTimeMonth: openedCheckBox
                  .getAt(openedCheckBox.length - 1)!
                  .dateTimeMonth,
              dateTimeDay:
                  openedCheckBox.getAt(openedCheckBox.length - 1)!.dateTimeDay,
            )
          : cityModelDaytimeNow();
      DateTime checkBoxDateTime = DateTime(
          int.parse(checkBoxInfo.dateTimeYear),
          int.parse(checkBoxInfo.dateTimeMonth),
          int.parse(checkBoxInfo.dateTimeDay));
      if (currentTime.difference(checkBoxDateTime).inDays < 2 &&
          isForceReloaded) {
        return null;
      }
      if (openedCheckBox.isEmpty ||
          currentTime.difference(checkBoxDateTime).inDays > 5 ||
          (currentTime.difference(checkBoxDateTime).inDays >= 2 &&
              isForceReloaded)) {
        for (String city in cities) {
          log(city);
          try {
            final airQualityData = await _getAirCityData(city: city);
            if (airQualityData == null) {
              continue;
            }
            //String cityMy = _getCity(city: airQualityData.place)
            final cityModel = CityModel(
              place: city,
              airQualityIndex: airQualityData.airQualityIndex.toString(),
              airQualityLevel: airQualityData.airQualityLevel.toString(),
              dateTimeYear: currentTime.year.toString(),
              dateTimeMonth: currentTime.month.toString(),
              dateTimeDay: currentTime.day.toString(),
            );
            final openBox = await Hive.openBox<CityModel>(city);

            await openBox.add(cityModel);
            listOfCityModel.add(cityModel);
            continue;
          } catch (e) {
            log(e.toString());
          }
          return listOfCityModel;
        }
      } else if (openedCheckBox.isNotEmpty &&
          currentTime.difference(checkBoxDateTime).inDays <= 5) {
        // for (int i = 0; i < cities.length; i++) {
        //   final openedBox = await Hive.openBox(cities[i]);
        //
        //   if (openedBox.isNotEmpty) {
        //TODO: implement data load from hive
        //   }
        // }
      }
    } catch (e) {
      rethrow;
    }
    return listOfCityModel;
  }
}
