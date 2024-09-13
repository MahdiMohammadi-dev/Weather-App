import 'package:weatherclean/core/resources/data_state.dart';
import 'package:weatherclean/core/usecase/usecase.dart';
import 'package:weatherclean/features/weather_feature/domain/entities/current_city_entitiy.dart';
import 'package:weatherclean/features/weather_feature/domain/repository/weather_repository.dart';

class GetCurrentWeatherUseCase extends UseCase<DataState<CurrentCityEntity>, String> {
  final WeatherRepository weatherRepository;

  GetCurrentWeatherUseCase(this.weatherRepository);

  @override
  Future<DataState<CurrentCityEntity>> call(String params) {
    return weatherRepository.fetchCurrentWeatherData(params);
  }
}
