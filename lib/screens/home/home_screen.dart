import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../bloc/air_condition_bloc.dart';
import 'details_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  static const String id = 'home_screen';

  static const String country = 'Ukraine';

  @override
  Widget build(BuildContext context) {
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
          )
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
                              color: index.isEven ? Colors.red : Colors.green,
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          state.factsModel.text!,
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
                  itemCount: state.airQualityData.length,
                  itemBuilder: (BuildContext context, int index) {
                    // final List city =
                    //     state.airQualityData[index].place!.split(',');
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, DetailsScreen.id);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        constraints: const BoxConstraints(
                          minHeight: 100,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:
                                ThemeData.dark().primaryColor.withOpacity(0.9),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'City: ' +
                                      (state.airQualityData[index].place ??
                                          'Unknown'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        letterSpacing: 0.2,
                                        wordSpacing: 0.5,
                                      ),
                                ),
                                textSizer(),
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
                                textSizer(),
                                Text(
                                  'Updated at: ' +
                                      (state.airQualityData[index].dateTimeDay +
                                          '.' +
                                          state.airQualityData[index]
                                              .dateTimeMonth +
                                          '.' +
                                          state.airQualityData[index]
                                              .dateTimeYear),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        letterSpacing: 0.2,
                                        wordSpacing: 0.5,
                                      ),
                                ),
                              ],
                            ),
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
                      color: index.isEven ? Colors.red : Colors.green,
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
