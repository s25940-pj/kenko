import 'package:json_annotation/json_annotation.dart';

enum MedicationType {
  @JsonValue('tablet')
  tablet,
  @JsonValue('capsule')
  capsule,
  @JsonValue('syrup')
  syrup,
  // @JsonValue('injection')
  // injection,
  // @JsonValue('ointment')
  // ointment,
  // @JsonValue('drop')
  // drop,
  // @JsonValue('inhaler')
  // inhaler,
  // @JsonValue('spray')
  // spray,
  // @JsonValue('patch')
  // patch,
  // @JsonValue('suppository')
  // suppository,
  // @JsonValue('implant')
  // implant,
  // @JsonValue('other')
  // other,
}
