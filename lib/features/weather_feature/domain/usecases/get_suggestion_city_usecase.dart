import 'package:weatherclean/core/usecase/usecase.dart';
import 'package:weatherclean/features/weather_feature/data/model/suggest_city_model.dart';
import 'package:weatherclean/features/weather_feature/domain/repository/weather_repository.dart';

class GetSuggestionCityUseCase implements UseCase<List<Data>, String> {
  final WeatherRepository weatherRepository;

  GetSuggestionCityUseCase(this.weatherRepository);

  @override
  Future<List<Data>> call(String params) {
    // TODO: implement call

    return weatherRepository.fetchSuggestData(params);
  }
}
