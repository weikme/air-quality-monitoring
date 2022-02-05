import 'package:cursach_diagrams/hive_models/city_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TimeDiagramWidget extends StatelessWidget {
  TimeDiagramWidget({required this.cityModel});

  final CityModel cityModel;

  final LineChartData _lineChartData = LineChartData();
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
            color: Color(0xff232d37)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LineChart(mainChart()),
        ));
  }

  LineChartData mainChart() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
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
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 14),

          ///[value] is basically numbers on top of the graph
          ///so there is a switch to place data correctly
          getTitles: (value) {
            print('bottomTitles $value');
            switch (value.toInt()) {
              case 0:
                return getDateFormat();
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
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 10,
      minY: 0,
      maxY: 150,
      lineBarsData: [
        LineChartBarData(
          spots: [
            ///x-axis - date, 0 == first date data received
            ///y-axis - airQualityIndex
            FlSpot(0, getAirQualityIndex()),
            // FlSpot(2.6, 121),
            // FlSpot(4.9, 119),
            // FlSpot(6.8, 3.1),
            // FlSpot(8, 4),
            // FlSpot(9.5, 3),
            // FlSpot(11, 4),
          ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  //TODO: as there are many CityModel models comes from hive
  //TODO: any kind of for loop is needed for dateTime
  //TODO: as well as for airQualityIndex in near future
  String getDateFormat() {
    String day = '${cityModel.dateTimeDay}.';
    String month = '${cityModel.dateTimeMonth}.';
    String year = cityModel.dateTimeYear;
    if (cityModel.dateTimeDay.length == 1) {
      day = '0${cityModel.dateTimeDay}.';
    }
    if (cityModel.dateTimeMonth.length == 1) {
      month = '0${cityModel.dateTimeMonth}.';
    }
    final dayMonthYear = day + month + year;
    return dayMonthYear;
  }

  double getAirQualityIndex() {
    if (cityModel.airQualityIndex == null) return 0;
    double airQualityIndex = double.parse(cityModel.airQualityIndex!);
    return airQualityIndex;
  }
}
