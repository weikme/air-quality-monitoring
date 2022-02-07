import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../hive_models/city_model.dart';
import '../../hive_models/list_of_city_models.dart';
import 'air_quality_utils.dart';

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
        borderRadius: isSmall
            ? const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              )
            : BorderRadius.zero,
        color: ThemeData.dark().primaryColor.withOpacity(0.9),
      ),
      padding: isSmall
          ? const EdgeInsets.all(8.0)
          : const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
        drawVerticalLine: false,
        drawHorizontalLine: isSmall ? false : true,
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
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 10,
          margin: 10,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),

          ///[value] is basically numbers on top of the graph
          ///so there is a switch to place data correctly
          getTitles: (value) {
            debugPrint('bottomTitles $value');
            switch (value.toInt()) {
              case 0:
                return getDateFormat(
                  cityModelList.listOfCityModels[value.toInt()]?.dateTime ??
                      DateTime.now(),
                );
            }
            return '';
          },
        ),

        ///right titles are needed as the library is not perfect enough
        rightTitles: SideTitles(
          showTitles: isSmall ? false : true,
          reservedSize: 20,
          getTextStyles: (context, value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 0),
          getTitles: (value) {
            return '';
          },
        ),
        leftTitles: isSmall ? SideTitles(showTitles: false) : null,
        topTitles: SideTitles(showTitles: false),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          left: BorderSide(color: Color(0xff37434d), width: 2),
          bottom: BorderSide(color: Color(0xff37434d), width: 2),
        ),
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

  double getAirQualityIndex() {
    if (cityModelList.listOfCityModels.first?.airQualityIndex == null) return 0;
    double airQualityIndex = double.parse(
        cityModelList.listOfCityModels.first?.airQualityIndex ?? '0');
    return airQualityIndex;
  }
}
