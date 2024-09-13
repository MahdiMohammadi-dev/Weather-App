import 'package:equatable/equatable.dart';
import 'package:weatherclean/features/weather_feature/data/model/suggest_city_model.dart';

class SuggestCityEntity extends Equatable {
  final List<Data>? data;
 final Metadata? metadata;


  SuggestCityEntity({this.data, this.metadata});

  @override
  // TODO: implement props
  List<Object?> get props => [data,metadata];

  @override
  // TODO: implement stringify
  bool? get stringify => true;

}
