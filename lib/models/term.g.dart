// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'term.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Term _$TermFromJson(Map<String, dynamic> json) => Term()
  ..id = json['id'] as num
  ..jahai_term = json['jahai_term'] as String?
  ..malay_term = json['malay_term'] as String?
  ..english_term = json['english_term'] as String?
  ..description = json['description'] as String?
  ..term_category = json['term_category'] as String?;

Map<String, dynamic> _$TermToJson(Term instance) => <String, dynamic>{
      'id': instance.id,
      'jahai_term': instance.jahai_term,
      'malay_term': instance.malay_term,
      'english_term': instance.english_term,
      'description': instance.description,
      'term_category': instance.term_category,
    };
