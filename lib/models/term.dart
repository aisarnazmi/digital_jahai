class Term {
  int id = 0;
  String jahaiTerm = "",
      malayTerm = "",
      englishTerm = "",
      description = "",
      termCategory = "";

  Term(
    this.id,
    this.jahaiTerm,
    this.malayTerm,
    this.englishTerm,
    this.description,
    this.termCategory,
  );

  Term.fromJson(dynamic json)
      : id = json['id'],
        jahaiTerm = json['jahai_term'],
        malayTerm = json['malay_term'],
        englishTerm = json['english_term'],
        description = json['description'],
        termCategory = json['term_category'];
}
