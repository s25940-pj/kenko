import 'package:json_annotation/json_annotation.dart';

enum MedicationDosageUnit {
  @JsonValue('mg')
  mg,
  @JsonValue('ml')
  ml,
  @JsonValue('units')
  units,
}
