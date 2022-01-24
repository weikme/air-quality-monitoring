import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cursach_diagrams/hive_models/city_model.dart';
import 'package:cursach_diagrams/utils/random_facts.dart';

import '../utils/air_condition.dart';

abstract class AirConditionBlocEvent {}

abstract class AirConditionBlocState {}

class AirConditionBlocInitialState extends AirConditionBlocState {}

class GetAirConditionValueByIPEvent extends AirConditionBlocEvent {}

class GetAirConditionValueByCityEvent extends AirConditionBlocEvent {
  String get myCity => city ?? '';

  String? city;

  GetAirConditionValueByCityEvent([this.city]);
}

class ReacquireAirConditionValueByCityEvent extends AirConditionBlocEvent {}

class AirConditionBloc
    extends Bloc<AirConditionBlocEvent, AirConditionBlocState> {
  final AirCondition _airCondition = AirCondition();
  final RandomFacts _randomFacts = RandomFacts();
  AirConditionBloc() : super(AirConditionBlocInitialState()) {
    on<AirConditionBlocEvent>(
      (event, emit) async {
        List<CityModel>? cityModelList = [];
        try {
          if (event is GetAirConditionValueByIPEvent) {
            final fact = await _randomFacts.fetchFact();

            emit(StateLoading(fact ?? ''));
            cityModelList.add((await _airCondition.getAirQualityFromIp())!);
            if (cityModelList.isNotEmpty) {
              emit(StateSuccess(cityModelList));
            }
          } else if (event is GetAirConditionValueByCityEvent) {
            String? fact = await _randomFacts.fetchFact();

            emit(StateLoading(fact ?? ''));
            cityModelList = await _airCondition.getAirQualityFromCity();
            if (cityModelList != null && cityModelList.isNotEmpty) {
              emit(StateSuccess(cityModelList));
            }
          } else if (event is ReacquireAirConditionValueByCityEvent) {
            final fact = await _randomFacts.fetchFact();

            emit(StateLoading(fact ?? ''));
            cityModelList = await _airCondition.getAirQualityFromCity(
                isForceReloaded: false);
            if (cityModelList != null && cityModelList.isNotEmpty) {
              emit(StateSuccess(cityModelList));
            } else {
              emit(StateLoadingErrorMessage(
                  'Can not reload as 2 days have not expired yet.'));
            }
          } else {
            emit(StateError());
          }
        } on Exception catch (e) {
          log('no data $e');
          emit(StateError());
        }
      },
    );
  }
}

class StateSuccess extends AirConditionBlocState {
  final List<CityModel> airQualityData;

  StateSuccess(this.airQualityData);
}

class StateLoading extends AirConditionBlocState {
  final String fact;

  StateLoading(this.fact);
}

class StateError extends AirConditionBlocState {}

class StateLoadingErrorMessage extends AirConditionBlocState {
  final String errorMessage;

  StateLoadingErrorMessage(this.errorMessage);
}
