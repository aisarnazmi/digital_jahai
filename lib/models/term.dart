import 'package:json_annotation/json_annotation.dart';

part 'term.g.dart';

@JsonSerializable()
class Term {
  Term();

  late String id;
  late String jahai_term;
  late String malay_term;
  late String english_term;
  late String description;
  late String term_category;
  
  factory Term.fromJson(Map<String,dynamic> json) => _$TermFromJson(json);
  Map<String, dynamic> toJson() => _$TermToJson(this);
}
