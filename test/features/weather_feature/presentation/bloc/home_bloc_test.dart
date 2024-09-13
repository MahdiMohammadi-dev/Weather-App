import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weatherclean/core/resources/data_state.dart';
import 'package:weatherclean/features/weather_feature/domain/entities/current_city_entitiy.dart';
import 'package:weatherclean/features/weather_feature/domain/usecases/get_current_weather_usecase.dart';
import 'package:weatherclean/features/weather_feature/domain/usecases/get_forecast_weather_usecase.dart';
import 'package:weatherclean/features/weather_feature/presentation/bloc/cw_status.dart';
import 'package:weatherclean/features/weather_feature/presentation/bloc/fw_status.dart';
import 'package:weatherclean/features/weather_feature/presentation/bloc/home_bloc.dart';

import 'home_bloc_test.mocks.dart';

@GenerateMocks([GetCurrentWeatherUseCase, GetforecastWeatherUseCase])
void main() {
  MockGetCurrentWeatherUseCase mockGetCurrentWeatherUseCase =
      MockGetCurrentWeatherUseCase();
  MockGetforecastWeatherUseCase mockGetforecastWeatherUseCas =
      MockGetforecastWeatherUseCase();

  String cityName = 'Tehran';
  String error = 'error';

  group('cw bloc test', () {
    when(mockGetCurrentWeatherUseCase.call(any)).thenAnswer(
        (_) async => Future.value(DataSuccess(CurrentCityEntity())));

    blocTest<HomeBloc, HomeState>(
      'emit loading and complete state',
      build: () => HomeBloc(mockGetCurrentWeatherUseCase,mockGetforecastWeatherUseCas),
      act: (bloc) {
        bloc.add(LoadCwEvent(cityName));
      },
      expect: () => <HomeState>[
        HomeState(cwStatus: CwLoading(), fwStatus: FwLoading()),
        HomeState(cwStatus: CwCompleted(CurrentCityEntity()), fwStatus: FwLoading()),
      ],
    );


  });




}
