import 'dart:developer';

import 'package:bloc/bloc.dart';

import '../hive_models/city_model.dart';
import '../hive_models/list_of_city_models.dart';
import '../models/random_facts_model.dart';
import '../utils/air_condition.dart';
import '../utils/random_facts.dart';

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
        List<ListOfCityModels> cityModelList = [];
        List<CityModel> cityModel = [];
        try {
          if (event is GetAirConditionValueByIPEvent) {
            RandomFactsModel? factsModel = await _randomFacts.fetchFact();

            emit(StateLoading(factsModel ?? RandomFactsModel(text: '')));
            cityModel.add((await _airCondition.getAirQualityFromIp())!);
            if (cityModelList.isNotEmpty) {
              emit(StateSuccess(byIp: cityModel));
            }
          } else if (event is GetAirConditionValueByCityEvent) {
            RandomFactsModel? factsModel = await _randomFacts.fetchFact();

            emit(StateLoading(factsModel ?? RandomFactsModel(text: '')));
            cityModelList = await _airCondition.getAirQualityFromCity() ?? [];
            if (cityModelList.isNotEmpty) {
              emit(StateSuccess(byCity: cityModelList));
            }
          } else if (event is ReacquireAirConditionValueByCityEvent) {
            RandomFactsModel? factsModel = await _randomFacts.fetchFact();

            emit(StateLoading(factsModel ?? RandomFactsModel(text: '')));
            cityModelList = await _airCondition.getAirQualityFromCity(
                    isForceReloaded: true) ??
                [];
            if (cityModelList.isNotEmpty) {
              emit(StateSuccess(byCity: cityModelList));
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
  final List<CityModel>? byIp;
  final List<ListOfCityModels>? byCity;

  StateSuccess({this.byIp, this.byCity});
}

class StateLoading extends AirConditionBlocState {
  final RandomFactsModel factsModel;

  StateLoading(this.factsModel);
}

class StateError extends AirConditionBlocState {}

class StateLoadingErrorMessage extends AirConditionBlocState {
  final String errorMessage;

  StateLoadingErrorMessage(this.errorMessage);
}
