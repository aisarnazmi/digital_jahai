// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'term.g.dart';

@JsonSerializable()
class Term {
  Term();

  late num id;
  String? jahai_term;
  String? malay_term;
  String? english_term;
  String? description;
  String? term_category;
  
  factory Term.fromJson(Map<String,dynamic> json) => _$TermFromJson(json);
  Map<String, dynamic> toJson() => _$TermToJson(this);
}
