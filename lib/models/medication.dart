import 'package:equatable/equatable.dart';

class Medication extends Equatable {
  final String name;
  final String company;

  const Medication(this.name, this.company);

  @override
  List<Object> get props => [name, company];

  @override
  String toString() => 'Medication { name: $name, company: $company }';
}
