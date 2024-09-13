


import 'package:weatherclean/core/resources/data_state.dart';
import 'package:weatherclean/features/bookamark_feature/data/data_source/local/city_dao.dart';
import 'package:weatherclean/features/bookamark_feature/domain/entities/city_entity.dart';
import 'package:weatherclean/features/bookamark_feature/domain/repository/city_repository.dart';

class CityRepositoryImpl extends CityRepository{

  CityDao cityDao;


  CityRepositoryImpl(this.cityDao);

  @override
  Future<DataState<String>> deleteCityByName(String name) async {
    // TODO: implement deleteCityByName

    try{
      await cityDao.deleteCityByName(name);
      return DataSuccess(name);
    }
    catch(e){
      print(e.toString());
      return DataFailed('Error in deleteCityByName for DB');

    }


  }

  @override
  Future<DataState<City>> findCityByName(String name) async {
    // TODO: implement findCityByName

    try{
      City? city = await cityDao.findCityByName(name);
      return DataSuccess(city);

    }
    catch(e){
      print(e.toString());
      return DataFailed('Error in findCityByName for DB');
    }

  }

  @override
  Future<DataState<List<City>>> getAllCityFromDb() async {
    // TODO: implement getAllCityFromDb

    try{
      List<City> cities =await cityDao.getAllCity();
      return DataSuccess(cities);
    }
    catch(e){
      print(e.toString());
      return DataFailed('Error in getAllCity From DB');
    }


  }

  @override
  Future<DataState<City>> saveCityToDb(String cityName) async {
    // TODO: implement saveCityToDb


    try{

      /// Check city has or not

      City? checkCity = await cityDao.findCityByName(cityName);
      if(checkCity!=null){
        return DataFailed('$cityName has Already Exist');
      }

      /// InsertCity to DB.

      City city = City(name: cityName);
      await cityDao.insertCity(city);
      return DataSuccess(city);

    }catch(e){
    print(e.toString());
    return DataFailed('Error in insert Data for DB');
    }


  }
}