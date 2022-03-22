class Term {
  int id = 0;
  String jahai_term = "",
      malay_term = "",
      english_term = "",
      description = "",
      term_category = "";

  Term(
    int id,
    String jahai_term,
    String malay_term,
    String english_term,
    String description,
    String term_category,
  ) {
    this.id = id;
    this.jahai_term = jahai_term;
    this.malay_term = malay_term;
    this.english_term = english_term;
    this.description = description;
    this.term_category = term_category;
  }

  Term.fromJson(dynamic json)
      : id = json['id'],
        jahai_term = json['jahai_term'],
        malay_term = json['malay_term'],
        english_term = json['english_term'],
        description = json['description'],
        term_category = json['term_category'];
}
