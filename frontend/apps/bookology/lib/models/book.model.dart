class BookModel {
  String _bookId = '';
  String _uploaderId = '';
  BookInformation _bookInformation = BookInformation(
    isbn: '',
    name: '',
    author: '',
    publisher: '',
  );
  AdditionalInformation _additionalInformation = AdditionalInformation(
    description: '',
    condition: '',
    imagesCollectionId: '',
    images: [],
  );
  Pricing _pricing = Pricing(
    originalPrice: '',
    sellingPrice: '',
  );
  CreatedOn _createdOn = CreatedOn(
    date: '',
    time: '',
  );
  Slugs _slugs = Slugs(
    name: '',
  );
  String _location = '';

  BookModel(
      {required String bookId,
      required String uploaderId,
      required BookInformation bookInformation,
      required AdditionalInformation additionalInformation,
      required Pricing pricing,
      required CreatedOn createdOn,
      required Slugs slugs,
      required String location}) {
    this._bookId = bookId;
    this._uploaderId = uploaderId;
    this._bookInformation = bookInformation;
    this._additionalInformation = additionalInformation;
    this._pricing = pricing;
    this._createdOn = createdOn;
    this._slugs = slugs;
    this._location = location;
  }

  String get bookId => _bookId;

  set bookId(String bookId) => _bookId = bookId;

  String get uploaderId => _uploaderId;

  set uploaderId(String uploaderId) => _uploaderId = uploaderId;

  BookInformation get bookInformation => _bookInformation;

  set bookInformation(BookInformation bookInformation) =>
      _bookInformation = bookInformation;

  AdditionalInformation get additionalInformation => _additionalInformation;

  set additionalInformation(AdditionalInformation additionalInformation) =>
      _additionalInformation = additionalInformation;

  Pricing get pricing => _pricing;

  set pricing(Pricing pricing) => _pricing = pricing;

  CreatedOn get createdOn => _createdOn;

  set createdOn(CreatedOn createdOn) => _createdOn = createdOn;

  Slugs get slugs => _slugs;

  set slugs(Slugs slugs) => _slugs = slugs;

  String get location => _location;

  set location(String location) => _location = location;

  BookModel.fromJson(Map<String, dynamic> json) {
    _bookId = json['book_id'];
    _uploaderId = json['uploader_id'];
    _bookInformation = (json['book_information'] != null
        ? new BookInformation.fromJson(json['book_information'])
        : null)!;
    _additionalInformation = (json['additional_information'] != null
        ? new AdditionalInformation.fromJson(json['additional_information'])
        : null)!;
    _pricing = (json['pricing'] != null
        ? new Pricing.fromJson(json['pricing'])
        : null)!;
    _createdOn = (json['created_on'] != null
        ? new CreatedOn.fromJson(json['created_on'])
        : null)!;
    _slugs =
        (json['slugs'] != null ? new Slugs.fromJson(json['slugs']) : null)!;
    _location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['book_id'] = this._bookId;
    data['uploader_id'] = this._uploaderId;
    if (this._bookInformation != null) {
      data['book_information'] = this._bookInformation.toJson();
    }
    if (this._additionalInformation != null) {
      data['additional_information'] = this._additionalInformation.toJson();
    }
    if (this._pricing != null) {
      data['pricing'] = this._pricing.toJson();
    }
    if (this._createdOn != null) {
      data['created_on'] = this._createdOn.toJson();
    }
    if (this._slugs != null) {
      data['slugs'] = this._slugs.toJson();
    }
    data['location'] = this._location;
    return data;
  }
}

class BookInformation {
  String _isbn = '';
  String _name = '';
  String _author = '';
  String _publisher = '';

  BookInformation(
      {required String isbn,
      required String name,
      required String author,
      required String publisher}) {
    this._isbn = isbn;
    this._name = name;
    this._author = author;
    this._publisher = publisher;
  }

  String get isbn => _isbn;

  set isbn(String isbn) => _isbn = isbn;

  String get name => _name;

  set name(String name) => _name = name;

  String get author => _author;

  set author(String author) => _author = author;

  String get publisher => _publisher;

  set publisher(String publisher) => _publisher = publisher;

  BookInformation.fromJson(Map<String, dynamic> json) {
    _isbn = json['isbn'];
    _name = json['name'];
    _author = json['author'];
    _publisher = json['publisher'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isbn'] = this._isbn;
    data['name'] = this._name;
    data['author'] = this._author;
    data['publisher'] = this._publisher;
    return data;
  }
}

class AdditionalInformation {
  String _description = '';
  String _condition = '';
  String _imagesCollectionId = '';
  List<String> _images = [];

  AdditionalInformation(
      {required String description,
      required String condition,
      required String imagesCollectionId,
      required List<String> images}) {
    this._description = description;
    this._condition = condition;
    this._imagesCollectionId = imagesCollectionId;
    this._images = images;
  }

  String get description => _description;

  set description(String description) => _description = description;

  String get condition => _condition;

  set condition(String condition) => _condition = condition;

  String get imagesCollectionId => _imagesCollectionId;

  set imagesCollectionId(String imagesCollectionId) =>
      _imagesCollectionId = imagesCollectionId;

  List<String> get images => _images;

  set images(List<String> images) => _images = images;

  AdditionalInformation.fromJson(Map<String, dynamic> json) {
    _description = json['description'];
    _condition = json['condition'];
    _imagesCollectionId = json['images_collection_id'];
    _images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this._description;
    data['condition'] = this._condition;
    data['images_collection_id'] = this._imagesCollectionId;
    data['images'] = this._images;
    return data;
  }
}

class Pricing {
  String _originalPrice = '';
  String _sellingPrice = '';

  Pricing({required String originalPrice, required String sellingPrice}) {
    this._originalPrice = originalPrice;
    this._sellingPrice = sellingPrice;
  }

  String get originalPrice => _originalPrice;

  set originalPrice(String originalPrice) => _originalPrice = originalPrice;

  String get sellingPrice => _sellingPrice;

  set sellingPrice(String sellingPrice) => _sellingPrice = sellingPrice;

  Pricing.fromJson(Map<String, dynamic> json) {
    _originalPrice = json['original_price'];
    _sellingPrice = json['selling_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['original_price'] = this._originalPrice;
    data['selling_price'] = this._sellingPrice;
    return data;
  }
}

class CreatedOn {
  String _date = '';
  String _time = '';

  CreatedOn({required String date, required String time}) {
    this._date = date;
    this._time = time;
  }

  String get date => _date;

  set date(String date) => _date = date;

  String get time => _time;

  set time(String time) => _time = time;

  CreatedOn.fromJson(Map<String, dynamic> json) {
    _date = json['date'];
    _time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this._date;
    data['time'] = this._time;
    return data;
  }
}

class Slugs {
  String _name = '';

  Slugs({required String name}) {
    this._name = name;
  }

  String get name => _name;

  set name(String name) => _name = name;

  Slugs.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    return data;
  }
}
