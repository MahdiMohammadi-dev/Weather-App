import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:weatherclean/core/params/forecast_params.dart';
import 'package:weatherclean/core/resources/data_state.dart';
import 'package:weatherclean/features/weather_feature/domain/usecases/get_current_weather_usecase.dart';
import 'package:weatherclean/features/weather_feature/domain/usecases/get_forecast_weather_usecase.dart';
import 'package:weatherclean/features/weather_feature/presentation/bloc/cw_status.dart';
import 'package:weatherclean/features/weather_feature/presentation/bloc/fw_status.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCurrentWeatherUseCase getCurrentWeatherUseCase;
  final GetforecastWeatherUseCase getforecastWeatherUseCase;

  HomeBloc(this.getCurrentWeatherUseCase, this.getforecastWeatherUseCase)
      : super(HomeState(
          cwStatus: CwLoading(),
          fwStatus: FwLoading(),
        )) {
    ///Current Weather Bloc

    on<LoadCwEvent>((event, emit) async {
      emit(state.copyWith(newCwStatus: CwLoading()));

      DataState dataState = await getCurrentWeatherUseCase(event.cityName);

      if (dataState is DataSuccess) {
        emit(state.copyWith(newCwStatus: CwCompleted(dataState.data)));
      }
      if (dataState is DataFailed) {
        emit(state.copyWith(newCwStatus: CwError(dataState.error!)));
      }
    });

    ///ForeCast Weather Bloc

    on<LoadFwEvent>((event, emit) async {
      emit(state.copyWith(newFwStatus: FwLoading()));

      DataState dataState =
          await getforecastWeatherUseCase(event.forecastParams);

      if (dataState is DataSuccess) {
        emit(state.copyWith(newFwStatus: FwCompleted(dataState.data)));
      }
      if (dataState is DataFailed) {
        emit(state.copyWith(newFwStatus: FwError(dataState.error!)));
      }
    });
  }
}
