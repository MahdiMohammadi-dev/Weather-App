



import 'package:weatherclean/core/resources/data_state.dart';
import 'package:weatherclean/features/bookamark_feature/domain/entities/city_entity.dart';

abstract class CityRepository{

  Future<DataState<City>> saveCityToDb(String cityName);

  Future<DataState<List<City>>> getAllCityFromDb();

  Future<DataState<City>> findCityByName(String name);

  Future<DataState<String>> deleteCityByName(String name);



}