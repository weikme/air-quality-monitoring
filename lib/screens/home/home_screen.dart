import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../bloc/air_condition_bloc.dart';
import '../../hive_models/list_of_city_models.dart';
import '../global/air_quality_utils.dart';
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
          'Country - $country',
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
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsScreen(
                              listOfModels: state.byCity?[index],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 120,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xff232d37),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:
                                ThemeData.dark().primaryColor.withOpacity(0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 8),
                              width: (width - 36) / 2,
                              constraints:
                                  BoxConstraints(maxWidth: (width - 36) / 2),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
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
                                  ),
                                  Flexible(
                                    child: Wrap(
                                      alignment: WrapAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      runAlignment: WrapAlignment.center,
                                      spacing: 0,
                                      runSpacing: 0,
                                      children: [
                                        Text(
                                          'Air Quality: ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.copyWith(
                                                letterSpacing: 0.5,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xff68737d),
                                              ),
                                        ),
                                        Text(
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
                                                //letterSpacing: 0.5,
                                                color: qualityLevelColor(state
                                                        .byCity?[index]
                                                        .listOfCityModels
                                                        .last
                                                        ?.airQualityLevel ??
                                                    ''),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: (width - 32) / 2,
                              constraints: const BoxConstraints(
                                  //maxWidth: (width - 32) / 2,
                                  maxHeight: 100),
                              child: TimeDiagramWidget(
                                cityModelList: state.byCity?[index] ??
                                    ListOfCityModels(city: 'Unknown'),
                                isSmall: true,
                              ),
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
}
