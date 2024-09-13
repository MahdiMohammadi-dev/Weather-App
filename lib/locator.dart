import 'package:get_it/get_it.dart';
import 'package:weatherclean/features/bookamark_feature/data/data_source/local/database.dart';
import 'package:weatherclean/features/bookamark_feature/data/repository/city_repository_impl.dart';
import 'package:weatherclean/features/bookamark_feature/domain/repository/city_repository.dart';
import 'package:weatherclean/features/bookamark_feature/domain/usecases/delete_city_usecase.dart';
import 'package:weatherclean/features/bookamark_feature/domain/usecases/get_all_city_usecase.dart';
import 'package:weatherclean/features/bookamark_feature/domain/usecases/get_city_usecase.dart';
import 'package:weatherclean/features/bookamark_feature/domain/usecases/save_city_usecase.dart';
import 'package:weatherclean/features/bookamark_feature/presentation/bloc/bookmark_bloc.dart';
import 'package:weatherclean/features/weather_feature/data/data_source/remote/api_provider.dart';
import 'package:weatherclean/features/weather_feature/data/repository/weather_repository_impl.dart';
import 'package:weatherclean/features/weather_feature/domain/repository/weather_repository.dart';
import 'package:weatherclean/features/weather_feature/domain/usecases/get_current_weather_usecase.dart';
import 'package:weatherclean/features/weather_feature/domain/usecases/get_forecast_weather_usecase.dart';
import 'package:weatherclean/features/weather_feature/presentation/bloc/home_bloc.dart';

GetIt locator = GetIt.instance;

setup() async {
  /// Di for Api Provider

  locator.registerSingleton<ApiProvider>(ApiProvider());

  /// Di for data base

  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();

  locator.registerSingleton<AppDatabase>(database);

  /// Di for Repository

  locator.registerSingleton<WeatherRepository>(WeatherRepositoryImp(locator()));
  locator
      .registerSingleton<CityRepository>(CityRepositoryImpl(database.cityDao));

  /// Di for GetCurrentWeather UseCases

  locator.registerSingleton<GetCurrentWeatherUseCase>(
      GetCurrentWeatherUseCase(locator()));

  locator.registerSingleton<GetforecastWeatherUseCase>(
      GetforecastWeatherUseCase(locator()));
  locator.registerSingleton<GetCityUsecase>(GetCityUsecase(locator()));
  locator.registerSingleton<SaveCityUseCase>(SaveCityUseCase(locator()));
  locator.registerSingleton<GetAllCityUseCase>(GetAllCityUseCase(locator()));
  locator
      .registerSingleton<GetDeleteCityUseCase>(GetDeleteCityUseCase(locator()));

  /// Di for Bloc

  locator.registerSingleton<HomeBloc>(HomeBloc(locator(), locator()));
  locator.registerSingleton<BookmarkBloc>(
      BookmarkBloc(locator(), locator(), locator(), locator()));
}
