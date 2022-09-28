// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Terms _$TermsFromJson(Map<String, dynamic> json) => Terms()
  ..terms = (json['terms'] as List<dynamic>)
      .map((e) => Term.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$TermsToJson(Terms instance) => <String, dynamic>{
      'terms': instance.terms,
    };
