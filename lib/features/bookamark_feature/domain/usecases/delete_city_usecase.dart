import 'package:weatherclean/core/resources/data_state.dart';
import 'package:weatherclean/core/usecase/usecase.dart';
import 'package:weatherclean/features/bookamark_feature/domain/repository/city_repository.dart';

class GetDeleteCityUseCase extends UseCase<DataState<String>, String> {
  final CityRepository cityRepository;

  GetDeleteCityUseCase(this.cityRepository);

  @override
  Future<DataState<String>> call(String params) {
    // TODO: implement call
    return cityRepository.deleteCityByName(params);
  }
}
