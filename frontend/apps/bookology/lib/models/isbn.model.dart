class IsbnModel {
  int? _isbn;
  String? _title;
  String? _author;
  String? _publishers;

  int? get isbn => _isbn;
  String? get title => _title;
  String? get author => _author;
  String? get publishers => _publishers;

  IsbnModel({int? isbn, String? title, String? author, String? publishers}) {
    _isbn = isbn;
    _title = title;
    _author = author;
    _publishers = publishers;
  }

  IsbnModel.fromJson(dynamic json) {
    _isbn = json["isbn"];
    _title = json["title"];
    _author = json["author"];
    _publishers = json["publishers"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["isbn"] = _isbn;
    map["title"] = _title;
    map["author"] = _author;
    map["publishers"] = _publishers;
    return map;
  }
}
