import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:weatherclean/features/weather_feature/domain/entities/forecast_days_entity.dart';

@immutable
abstract class FwStatus extends Equatable {}

/// Loadings Status

class FwLoading extends FwStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

/// Completed Status

class FwCompleted extends FwStatus {
  final ForecastDaysEntity forecastDaysEntity;

  FwCompleted(this.forecastDaysEntity);

  @override
  // TODO: implement props
  List<Object?> get props => [forecastDaysEntity];
}

/// Error Status

class FwError extends FwStatus {
  final String error;

  FwError(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
