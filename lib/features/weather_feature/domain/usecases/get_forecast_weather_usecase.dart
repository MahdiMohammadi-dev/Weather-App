import 'package:weatherclean/core/params/forecast_params.dart';
import 'package:weatherclean/core/resources/data_state.dart';
import 'package:weatherclean/core/usecase/usecase.dart';
import 'package:weatherclean/features/weather_feature/domain/entities/forecast_days_entity.dart';
import 'package:weatherclean/features/weather_feature/domain/repository/weather_repository.dart';

class GetforecastWeatherUseCase
    extends UseCase<DataState<ForecastDaysEntity>, ForecastParams> {
  final WeatherRepository weatherRepository;

  GetforecastWeatherUseCase(this.weatherRepository);

  @override
  Future<DataState<ForecastDaysEntity>> call(ForecastParams params) {
    return weatherRepository.fetchForecastWeatherData(params);
  }
}
