import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

/// This is a Entity Class for Floor DB

@entity
class City extends Equatable {
  @PrimaryKey(autoGenerate: true)
  int? id;

  final String name;

  City({required this.name});

  @override
  // TODO: implement props
  List<Object?> get props => [name];
}
