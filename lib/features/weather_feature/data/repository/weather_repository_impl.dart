import 'package:dio/dio.dart';
import 'package:weatherclean/core/params/forecast_params.dart';
import 'package:weatherclean/core/resources/data_state.dart';
import 'package:weatherclean/features/weather_feature/data/data_source/remote/api_provider.dart';
import 'package:weatherclean/features/weather_feature/data/model/current_city_model.dart';
import 'package:weatherclean/features/weather_feature/data/model/forecast_days_model.dart';
import 'package:weatherclean/features/weather_feature/data/model/suggest_city_model.dart';
import 'package:weatherclean/features/weather_feature/domain/entities/current_city_entitiy.dart';
import 'package:weatherclean/features/weather_feature/domain/entities/forecast_days_entity.dart';
import 'package:weatherclean/features/weather_feature/domain/entities/suggest_city_entitiy.dart';
import 'package:weatherclean/features/weather_feature/domain/repository/weather_repository.dart';

class WeatherRepositoryImp extends WeatherRepository {
  ApiProvider apiProvider;

  WeatherRepositoryImp(this.apiProvider);

  @override
  Future<DataState<CurrentCityEntity>> fetchCurrentWeatherData(
      String cityName) async {
    try {
      Response response = await apiProvider.callCurrentWeather(cityName);

      if (response.statusCode == 200) {
        CurrentCityEntity currentCityEntity =
        CurrentCityModel.fromJson(response.data);

        return DataSuccess(currentCityEntity);
      } else {
        return DataFailed('Error please Try Again...');
      }
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<ForecastDaysEntity>> fetchForecastWeatherData(
      ForecastParams params) async {
    try {
      Response response = await apiProvider.sendRequest7DaysForecast(params);

      if (response.statusCode == 200) {
        ForecastDaysEntity forecastDaysEntity =
            ForecastDaysModel.fromJson(response.data);
        return DataSuccess(forecastDaysEntity);
      } else {
        return DataFailed("Something Went Wrong. try again...");
      }
    } catch (e) {
      print(e.toString());
      return DataFailed("please check your connection...");
    }
  }

  @override
  Future<List<Data>> fetchSuggestData(cityName) async {
    Response response =
        await apiProvider.sendRequestCityForSuggestion(cityName);

    SuggestCityEntity suggestCityEntity = SuggestCityModel.fromJson(response.data);

    return suggestCityEntity.data!;
  }
}
