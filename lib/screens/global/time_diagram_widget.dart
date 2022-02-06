import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../hive_models/city_model.dart';
import '../../hive_models/list_of_city_models.dart';

class TimeDiagramWidget extends StatelessWidget {
  TimeDiagramWidget({required this.cityModelList, this.isSmall = false});

  final ListOfCityModels cityModelList;
  final bool isSmall;

  final LineChartData _lineChartData = LineChartData();
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        color: ThemeData.dark().primaryColor.withOpacity(0.9),
      ),
      padding: const EdgeInsets.all(8.0),
      child: LineChart(
        mainChart(),
        swapAnimationDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  LineChartData mainChart() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        drawHorizontalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        ///isSmall - for details_screen.dart
        ///!isSmall - for home_screen.dart
        show: isSmall ? false : true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),

          ///[value] is basically numbers on top of the graph
          ///so there is a switch to place data correctly
          getTitles: (value) {
            debugPrint('bottomTitles $value');
            switch (value.toInt()) {
              case 0:
                return cityModelList.listOfCityModels[value.toInt()]?.dateTime
                        .toString() ??
                    '';
              case 1:
                return cityModelList.listOfCityModels[value.toInt()]?.dateTime
                        .toString() ??
                    '';
              case 2:
                return cityModelList.listOfCityModels[value.toInt()]?.dateTime
                        .toString() ??
                    '';
              case 3:
                return cityModelList.listOfCityModels[value.toInt()]?.dateTime
                        .toString() ??
                    '';
              case 4:
                return cityModelList.listOfCityModels[value.toInt()]?.dateTime
                        .toString() ??
                    '';
              case 5:
                return '04.02.2022';
              case 8:
                return '07.02.2022';
            }
            return '';
          },
        ),

        ///right titles are needed as the library is not perfect enough
        rightTitles: SideTitles(
          showTitles: true,
          reservedSize: 20,
          getTextStyles: (context, value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 0),
          getTitles: (value) {
            return '';
          },
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border.symmetric(),
        //border: Border.all(color: const Color(0xff37434d), width: 1)
      ),
      minX: 0,
      maxX: 10,
      minY: 0,
      maxY: 150,
      lineBarsData: [
        LineChartBarData(
          ///x-axis - date, 0 == first date data received
          ///y-axis - airQualityIndex
          spots: cityModelList.listOfCityModels
              .asMap()
              .map((int index, CityModel? cityModel) {
                return MapEntry(
                  index,
                  FlSpot(
                    index.toDouble(),
                    double.parse(cityModel?.airQualityIndex ?? '0'),
                  ),
                );
              })
              .values
              .toList(),
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColors
                .map(
                  (color) => color.withOpacity(0.3),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  // double getAirQualityIndex() {
  //   if (cityModelList.listOfCityModels.first?.airQualityIndex == null) return 0;
  //   double airQualityIndex = double.parse(
  //       cityModelList.listOfCityModels.first?.airQualityIndex ?? '0');
  //   return airQualityIndex;
  // }
}
