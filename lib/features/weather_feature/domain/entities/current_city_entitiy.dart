

import 'package:equatable/equatable.dart';
import 'package:weatherclean/features/weather_feature/data/model/current_city_model.dart';

class CurrentCityEntity extends Equatable{

 final Coord? coord;
 final List<Weather>? weather;
 final String? base;
 final Main? main;
 final num? visibility;
 final Wind? wind;
 final Clouds? clouds;
 final num? dt;
 final Sys? sys;
 final num? timezone;
 final num? id;
 final String? name;
 final num? cod;


 const CurrentCityEntity({
      this.coord,
      this.weather,
      this.base,
      this.main,
      this.visibility,
      this.wind,
      this.clouds,
      this.dt,
      this.sys,
      this.timezone,
      this.id,
      this.name,
      this.cod});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}