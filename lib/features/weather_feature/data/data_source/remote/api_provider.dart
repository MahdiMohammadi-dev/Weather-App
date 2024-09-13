import 'package:dio/dio.dart';
import 'package:weatherclean/core/params/forecast_params.dart';
import 'package:weatherclean/core/utils/constants.dart';

class ApiProvider {
  final Dio _dio = Dio();

  var apiKey = Constants.apiKey;

  ///call api from server
  ///current weather api
  Future<dynamic> callCurrentWeather(cityName) async {
    var response = await _dio
        .get('${Constants.baseUrl}data/2.5/weather', queryParameters: {
      'q': cityName,
      'appid': apiKey,
      'units': 'metric',
    });

    return response;
  }

  /// 7 days Forecast Api Call

  Future<dynamic> sendRequest7DaysForecast(ForecastParams params) async {
    var response = await _dio
        .get("${Constants.baseUrl}data/2.5/forecast", queryParameters: {
      'lat': params.lat,
      'lon': params.lon,
      'exclude': 'minutely,hourly',
      'appid': apiKey,
      'units': 'metric'
    });
    print('this is data ${response.data}');
    return response;
  }

  /// Search City Api

  Future<dynamic> sendRequestCityForSuggestion(String prefix) async {
    var response = await _dio.get(
        'http://geodb-free-service.wirefreethought.com/v1/geo/cities',
        queryParameters: {'limit': 7, 'offset': 0, 'namePrefix': prefix});

    return response;
  }
}
