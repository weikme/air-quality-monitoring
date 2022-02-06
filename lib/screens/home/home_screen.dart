import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../bloc/air_condition_bloc.dart';
import '../../hive_models/list_of_city_models.dart';
import '../global/time_diagram_widget.dart';
import 'details_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  static const String id = 'home_screen';

  static const String country = 'Ukraine';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Country - ' + country,
        ),
        titleTextStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
              wordSpacing: 0.5,
            ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<AirConditionBloc>().add(
                    GetAirConditionValueByCityEvent(),
                  );
            },
            child: const Text(
              'Reload',
            ),
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(24)),
                ),
              ),
            ),
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),
        ),
      ),
      body: SafeArea(
        child: BlocListener<AirConditionBloc, AirConditionBlocState>(
          listener: (context, state) {
            if (state is StateError) {
              Container(
                color: Colors.red,
              );
            }
          },
          child: BlocBuilder<AirConditionBloc, AirConditionBlocState>(
            bloc: context.read<AirConditionBloc>(),
            builder: (BuildContext context, AirConditionBlocState state) {
              if (state is StateLoading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(),
                      SpinKitFadingCircle(
                        itemBuilder: (BuildContext context, int index) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              color: index.isEven ? Colors.blue : Colors.yellow,
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Fun fact: ' + state.factsModel.text!,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: 0.2,
                                    wordSpacing: 0.5,
                                  ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (state is StateError) {
                return const ScaffoldMessenger(
                  child: Text('error'),
                );
              }
              if (state is StateLoadingErrorMessage) {
                return ScaffoldMessenger(
                  child: Text(state.errorMessage),
                );
              }
              if (state is StateSuccess) {
                return ListView.builder(
                  itemCount: state.byCity?.length,
                  itemBuilder: (BuildContext context, int index) {
                    // final List city =
                    //     state.airQualityData[index].place!.split(',');
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, DetailsScreen.id);
                      },
                      child: Container(
                        height: 120,
                        //padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Color(0xff232d37),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:
                                ThemeData.dark().primaryColor.withOpacity(0.9),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'City:\n' +
                                        (state.byCity?[index].city ??
                                            'Unknown'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                          //wordSpacing: 0.5,
                                        ),
                                  ),
                                  Text(
                                    'Air Quality:\n' +
                                        qualityLevel(state
                                                .byCity?[index]
                                                .listOfCityModels
                                                .last
                                                ?.airQualityLevel ??
                                            ''),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.5,
                                          color: Color(0xff68737d),
                                          //wordSpacing: 0.5,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 4.0, right: 8),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth: width / 2, maxHeight: 100),
                                child: TimeDiagramWidget(
                                  cityModelList: state.byCity?[index] ??
                                      ListOfCityModels(city: 'Unknown'),
                                  isSmall: true,
                                ),
                              ),
                            ),
                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            //   children: [

                            //TODO: remove, add info below on details_screen.dart
                            // Text(
                            //   'Quality level: ' +
                            //       qualityLevel(state.airQualityData[index]
                            //               .airQualityLevel ??
                            //           ''),
                            //   style: Theme.of(context)
                            //       .textTheme
                            //       .bodyText1
                            //       ?.copyWith(
                            //         fontSize: 16,
                            //         fontWeight: FontWeight.w300,
                            //         letterSpacing: 0.2,
                            //         wordSpacing: 0.5,
                            //       ),
                            // ),
                            // textSizer(),
                            // Text(
                            //   'Quality index: ' +
                            //       (state.airQualityData[index]
                            //               .airQualityIndex ??
                            //           'Unknown'),
                            //   style: Theme.of(context)
                            //       .textTheme
                            //       .bodyText1
                            //       ?.copyWith(
                            //         fontSize: 16,
                            //         fontWeight: FontWeight.w300,
                            //         letterSpacing: 0.2,
                            //         wordSpacing: 0.5,
                            //       ),
                            // ),
                            // textSizer(),
                            // Text(
                            //   'Updated at: ' +
                            //       (state.airQualityData[index].dateTimeDay +
                            //           '.' +
                            //           state.airQualityData[index]
                            //               .dateTimeMonth +
                            //           '.' +
                            //           state.airQualityData[index]
                            //               .dateTimeYear),
                            //   style: Theme.of(context)
                            //       .textTheme
                            //       .bodyText1
                            //       ?.copyWith(
                            //         fontSize: 16,
                            //         fontWeight: FontWeight.w300,
                            //         letterSpacing: 0.2,
                            //         wordSpacing: 0.5,
                            //       ),
                            // ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              return SpinKitFadingCircle(
                itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: index.isEven ? Colors.blue : Colors.yellow,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  String qualityLevel(String airQualityLevel) {
    switch (airQualityLevel) {
      case 'AirQualityLevel.GOOD':
        return 'Good';
      case 'AirQualityLevel.HAZARDOUS':
        return 'Hazardous';
      case 'AirQualityLevel.VERY_UNHEALTHY':
        return 'Very Unhealthy';
      case 'AirQualityLevel.MODERATE':
        return 'Moderate';
      case 'AirQualityLevel.UNHEALTHY':
        return 'Unhealthy';
      case 'AirQualityLevel.UNHEALTHY_FOR_SENSITIVE_GROUPS':
        return 'Unhealthy for sensitive groups';
      case 'AirQualityLevel.UNKNOWN':
        return 'Unknown';
      default:
        return 'Unknown';
    }
  }

  final TextStyle? cityInfoTextTheme = const TextTheme().bodyText1?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w300,
        // letterSpacing: 0.2,
        wordSpacing: 0.5,
      );

  Widget textSizer() {
    return const SizedBox(
      height: 4,
    );
  }
}
