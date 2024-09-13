import 'package:weatherclean/core/resources/data_state.dart';
import 'package:weatherclean/core/usecase/usecase.dart';
import 'package:weatherclean/features/bookamark_feature/domain/entities/city_entity.dart';
import 'package:weatherclean/features/bookamark_feature/domain/repository/city_repository.dart';
import 'package:weatherclean/features/weather_feature/data/model/suggest_city_model.dart';

class GetAllCityUseCase extends UseCase<DataState<List<City>>, NoParams> {
  final CityRepository cityRepository;

  GetAllCityUseCase(this.cityRepository);

  @override
  Future<DataState<List<City>>> call(NoParams params) {
    // TODO: implement call
    return cityRepository.getAllCityFromDb();
  }
}
