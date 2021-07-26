class Book {
  String? _id;
  String? _isbn;
  String? _uploaderId;
  String? _bookName;
  String? _bookAuthor;
  String? _bookPublisher;
  String? _description;
  String? _originalPrice;
  String? _sellingPrice;
  String? _bookCondition;
  String? _bookImagesUrls;
  String? _uploadDate;
  String? _uploadTime;
  String? _bookNameSlug;
  dynamic? _location;

  String? get id => _id;

  String? get isbn => _isbn;

  String? get uploaderId => _uploaderId;

  String? get bookName => _bookName;

  String? get bookAuthor => _bookAuthor;

  String? get bookPublisher => _bookPublisher;

  String? get description => _description;

  String? get originalPrice => _originalPrice;

  String? get sellingPrice => _sellingPrice;

  String? get bookCondition => _bookCondition;

  String? get bookImagesUrls => _bookImagesUrls;

  String? get uploadDate => _uploadDate;

  String? get uploadTime => _uploadTime;

  String? get bookNameSlug => _bookNameSlug;

  dynamic? get location => _location;

  Book(
      {String? id,
      String? isbn,
      String? uploaderId,
      String? bookName,
      String? bookAuthor,
      String? bookPublisher,
      String? description,
      String? originalPrice,
      String? sellingPrice,
      String? bookCondition,
      String? bookImagesUrls,
      String? uploadDate,
      String? uploadTime,
      String? bookNameSlug,
      dynamic? location}) {
    _id = id;
    _isbn = isbn;
    _uploaderId = uploaderId;
    _bookName = bookName;
    _bookAuthor = bookAuthor;
    _bookPublisher = bookPublisher;
    _description = description;
    _originalPrice = originalPrice;
    _sellingPrice = sellingPrice;
    _bookCondition = bookCondition;
    _bookImagesUrls = bookImagesUrls;
    _uploadDate = uploadDate;
    _uploadTime = uploadTime;
    _bookNameSlug = bookNameSlug;
    _location = location;
  }

  Book.fromJson(dynamic json) {
    _id = json["_id"];
    _isbn = json["isbn"];
    _uploaderId = json["uploader_id"];
    _bookName = json["book_name"];
    _bookAuthor = json["book_author"];
    _bookPublisher = json["book_publisher"];
    _description = json["description"];
    _originalPrice = json["original_price"];
    _sellingPrice = json["selling_price"];
    _bookCondition = json["book_condition"];
    _bookImagesUrls = json["book_images_urls"];
    _uploadDate = json["upload_date"];
    _uploadTime = json["upload_time"];
    _bookNameSlug = json["book_name_slug"];
    _location = json["location"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["_id"] = _id;
    map["isbn"] = _isbn;
    map["uploader_id"] = _uploaderId;
    map["book_name"] = _bookName;
    map["book_author"] = _bookAuthor;
    map["book_publisher"] = _bookPublisher;
    map["description"] = _description;
    map["original_price"] = _originalPrice;
    map["selling_price"] = _sellingPrice;
    map["book_condition"] = _bookCondition;
    map["book_images_urls"] = _bookImagesUrls;
    map["upload_date"] = _uploadDate;
    map["upload_time"] = _uploadTime;
    map["book_name_slug"] = _bookNameSlug;
    map["location"] = _location;
    return map;
  }
}
