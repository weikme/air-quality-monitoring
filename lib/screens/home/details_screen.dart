import 'package:flutter/material.dart';

import '../../hive_models/list_of_city_models.dart';
import '../global/air_quality_utils.dart';
import '../global/time_diagram_widget.dart';

class DetailsScreen extends StatelessWidget {
  DetailsScreen({Key? key, ListOfCityModels? listOfModels})
      : listOfCityModels = listOfModels ?? ListOfCityModels(),
        super(key: key);
  ListOfCityModels listOfCityModels;
  static const String id = 'details_screen';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final textStyle = Theme.of(context).textTheme.bodyText1?.copyWith(
        fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey);
    final textStyleColored = Theme.of(context).textTheme.bodyText1;
    return Scaffold(
      appBar: AppBar(
        title: const Text('City Details'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
              height: height / 4,
              child: TimeDiagramWidget(cityModelList: listOfCityModels)),
          const Spacer(),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                runAlignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 32,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'City: ',
                      style: textStyle,
                      children: [
                        TextSpan(
                          text: listOfCityModels.city,
                          style: textStyle?.copyWith(color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Last Updated At: ',
                      style: textStyle,
                      children: [
                        TextSpan(
                          text: getDateFormat(listOfCityModels
                              .listOfCityModels.last!.dateTime!),
                          style: textStyle?.copyWith(
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Air Quality Index: ',
                      style: textStyle,
                      children: [
                        TextSpan(
                          text: listOfCityModels
                              .listOfCityModels.last?.airQualityIndex,
                          style: textStyleColored?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: qualityLevelColor(listOfCityModels
                                .listOfCityModels.last!.airQualityLevel!),
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Air Quality: ',
                      style: textStyle,
                      children: [
                        TextSpan(
                          text: qualityLevel(listOfCityModels
                              .listOfCityModels.last!.airQualityLevel!),
                          style: textStyleColored?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: qualityLevelColor(listOfCityModels
                                .listOfCityModels.last!.airQualityLevel!),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(
            flex: 6,
          ),
        ],
      ),
    );
  }
}
