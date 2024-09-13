


import 'package:weatherclean/core/resources/data_state.dart';
import 'package:weatherclean/core/usecase/usecase.dart';
import 'package:weatherclean/features/bookamark_feature/domain/entities/city_entity.dart';
import 'package:weatherclean/features/bookamark_feature/domain/repository/city_repository.dart';

class GetCityUsecase extends UseCase<DataState<City> , String>{

  final CityRepository cityRepository;

  GetCityUsecase(this.cityRepository);

  @override
  Future<DataState<City>> call(String params) {
    // TODO: implement call

    return cityRepository.findCityByName(params);

  }

}