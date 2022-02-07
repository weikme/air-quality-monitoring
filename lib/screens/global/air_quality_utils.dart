import 'package:flutter/material.dart';

String qualityLevel(String airQualityLevel) {
  switch (airQualityLevel) {
    case 'AirQualityLevel.GOOD':
      return 'Good';
    case 'AirQualityLevel.MODERATE':
      return 'Moderate';
    case 'AirQualityLevel.UNHEALTHY_FOR_SENSITIVE_GROUPS':
      return 'Unhealthy for sensitive groups';
    case 'AirQualityLevel.UNHEALTHY':
      return 'Unhealthy';
    case 'AirQualityLevel.VERY_UNHEALTHY':
      return 'Very Unhealthy';
    case 'AirQualityLevel.HAZARDOUS':
      return 'Hazardous';
    case 'AirQualityLevel.UNKNOWN':
      return 'Unknown';
    default:
      return 'Unknown';
  }
}

Color qualityLevelColor(String airQualityLevel) {
  switch (airQualityLevel) {
    case 'AirQualityLevel.GOOD':
      return Colors.green;
    case 'AirQualityLevel.MODERATE':
      return Colors.yellow;
    case 'AirQualityLevel.UNHEALTHY_FOR_SENSITIVE_GROUPS':
      return Colors.orange;
    case 'AirQualityLevel.UNHEALTHY':
      return Colors.red;
    case 'AirQualityLevel.VERY_UNHEALTHY':
      return Colors.purple;
    case 'AirQualityLevel.HAZARDOUS':
      return Colors.brown;
    case 'AirQualityLevel.UNKNOWN':
      return Colors.grey;
    default:
      return Colors.grey;
  }
}

String getDateFormat(DateTime dateTime) {
  String day = '${dateTime.day}.';
  String month = '${dateTime.month}.';
  String year = '${dateTime.year}';
  if (day.length == 2) {
    day = '0${dateTime.day}.';
  }
  if (month.length == 2) {
    month = '0${dateTime.month}.';
  }
  return day + month + year;
}
