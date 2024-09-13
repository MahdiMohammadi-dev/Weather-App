import 'package:weatherclean/core/params/forecast_params.dart';
import 'package:weatherclean/core/resources/data_state.dart';
import 'package:weatherclean/features/weather_feature/data/model/suggest_city_model.dart';
import 'package:weatherclean/features/weather_feature/domain/entities/current_city_entitiy.dart';
import 'package:weatherclean/features/weather_feature/domain/entities/forecast_days_entity.dart';

abstract class WeatherRepository {
  Future<DataState<CurrentCityEntity>> fetchCurrentWeatherData(String cityName);

  Future<DataState<ForecastDaysEntity>> fetchForecastWeatherData(ForecastParams params);

  Future<List<Data>> fetchSuggestData(cityName);
}
