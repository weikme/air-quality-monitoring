import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../bloc/air_condition_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String id = 'home_screen';

  static const String country = 'Ukraine';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            state.fact,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                if (state is StateError) {
                  return ScaffoldMessenger(
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
                      return Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:
                                ThemeData.dark().primaryColor.withOpacity(0.9),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            (state.airQualityData[index].place ?? 'No City') +
                                (state.airQualityData[index].airQualityLevel ??
                                    'data'),
                          ),
                        ),
                      );
                    },
                  );
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // FloatingActionButton(
          //   heroTag: HeroTag('dajkshd'),
          //   onPressed: () {
          //     context
          //         .read<AirConditionBloc>()
          //         .add(GetAirConditionValueByIPEvent());
          //   },
          //   tooltip: 'Increment',
          //   child: const Icon(Icons.add),
          // ),
          FloatingActionButton(
            onPressed: () {
              context.read<AirConditionBloc>().add(
                    GetAirConditionValueByCityEvent(),
                  );
            },
            tooltip: 'Increment',
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
