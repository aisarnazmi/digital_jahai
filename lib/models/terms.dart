// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import "term.dart";

part 'terms.g.dart';

@JsonSerializable()
class Terms {
  Terms();

  late List<Term> terms;
  
  factory Terms.fromJson(Map<String,dynamic> json) => _$TermsFromJson(json);
  Map<String, dynamic> toJson() => _$TermsToJson(this);

  static Terms parseTerms(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    List<Term> termsList =
        parsed.map<Term>((json) => Term.fromJson(json)).toList();
    Terms t = Terms();
    t.terms = termsList;
    return t;
  }
}
