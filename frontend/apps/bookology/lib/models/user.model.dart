
/*
 * Copyright 2021 Mihir Paldhikar
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 *  the Software, and to permit persons to whom the Software is furnished to do so,
 *  subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 *  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
 *  ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 *  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 *  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

class UserModel {
  String _userId = '';
  UserInformation _userInformation = UserInformation(
      username: '',
      verified: false,
      bio: '',
      profilePicture: '',
      email: '',
      firstName: '',
      lastName: '');
  Providers _providers = Providers(auth: '');
  AdditionalInformation _additionalInformation =
      AdditionalInformation(suspended: false, emailVerified: false);
  JoinedOn _joinedOn = JoinedOn(date: '', time: '');
  Slugs _slugs = Slugs(username: '', firstName: '', lastName: '');
  List<Books> _books = [];

  UserModel(
      {required String userId,
      required UserInformation userInformation,
      required Providers providers,
      required AdditionalInformation additionalInformation,
      required JoinedOn joinedOn,
      required Slugs slugs,
      required List<Books> books}) {
    this._userId = userId;
    this._userInformation = userInformation;
    this._providers = providers;
    this._additionalInformation = additionalInformation;
    this._joinedOn = joinedOn;
    this._slugs = slugs;
    this._books = books;
  }

  String get userId => _userId;

  set userId(String userId) => _userId = userId;

  UserInformation get userInformation => _userInformation;

  set userInformation(UserInformation userInformation) =>
      _userInformation = userInformation;

  Providers get providers => _providers;

  set providers(Providers providers) => _providers = providers;

  AdditionalInformation get additionalInformation => _additionalInformation;

  set additionalInformation(AdditionalInformation additionalInformation) =>
      _additionalInformation = additionalInformation;

  JoinedOn get joinedOn => _joinedOn;

  set joinedOn(JoinedOn joinedOn) => _joinedOn = joinedOn;

  Slugs get slugs => _slugs;

  set slugs(Slugs slugs) => _slugs = slugs;

  List<Books> get books => _books;

  set books(List<Books> books) => _books = books;

  UserModel.fromJson(Map<String, dynamic> json) {
    _userId = json['user_id'];
    _userInformation = (json['user_information'] != null
        ? new UserInformation.fromJson(json['user_information'])
        : null)!;
    _providers = (json['providers'] != null
        ? new Providers.fromJson(json['providers'])
        : null)!;
    _additionalInformation = (json['additional_information'] != null
        ? new AdditionalInformation.fromJson(json['additional_information'])
        : null)!;
    _joinedOn = (json['joined_on'] != null
        ? new JoinedOn.fromJson(json['joined_on'])
        : null)!;
    _slugs =
        (json['slugs'] != null ? new Slugs.fromJson(json['slugs']) : null)!;
    if (json['books'] != null) {
      _books = [];
      json['books'].forEach((v) {
        _books.add(new Books.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this._userId;
    if (this._userInformation != null) {
      data['user_information'] = this._userInformation.toJson();
    }
    if (this._providers != null) {
      data['providers'] = this._providers.toJson();
    }
    if (this._additionalInformation != null) {
      data['additional_information'] = this._additionalInformation.toJson();
    }
    if (this._joinedOn != null) {
      data['joined_on'] = this._joinedOn.toJson();
    }
    if (this._slugs != null) {
      data['slugs'] = this._slugs.toJson();
    }
    if (this._books != null) {
      data['books'] = this._books.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserInformation {
  String _username = '';
  bool _verified = false;
  String _bio = '';
  String _profilePicture = '';
  String _email = '';
  String _firstName = '';
  String _lastName = '';

  UserInformation(
      {required String username,
      required bool verified,
      required String bio,
      required String profilePicture,
      required String email,
      required String firstName,
      required String lastName}) {
    this._username = username;
    this._verified = verified;
    this._bio = bio;
    this._profilePicture = profilePicture;
    this._email = email;
    this._firstName = firstName;
    this._lastName = lastName;
  }

  String get username => _username;

  set username(String username) => _username = username;

  bool get verified => _verified;

  set verified(bool verified) => _verified = verified;

  String get bio => _bio;

  set bio(String bio) => _bio = bio;

  String get profilePicture => _profilePicture;

  set profilePicture(String profilePicture) => _profilePicture = profilePicture;

  String get email => _email;

  set email(String email) => _email = email;

  String get firstName => _firstName;

  set firstName(String firstName) => _firstName = firstName;

  String get lastName => _lastName;

  set lastName(String lastName) => _lastName = lastName;

  UserInformation.fromJson(Map<String, dynamic> json) {
    _username = json['username'];
    _verified = json['verified'];
    _bio = json['bio'];
    _profilePicture = json['profile_picture'];
    _email = json['email'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this._username;
    data['verified'] = this._verified;
    data['bio'] = this._bio;
    data['profile_picture'] = this._profilePicture;
    data['email'] = this._email;
    data['first_name'] = this._firstName;
    data['last_name'] = this._lastName;
    return data;
  }
}

class Providers {
  String _auth = '';

  Providers({required String auth}) {
    this._auth = auth;
  }

  String get auth => _auth;

  set auth(String auth) => _auth = auth;

  Providers.fromJson(Map<String, dynamic> json) {
    _auth = json['auth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['auth'] = this._auth;
    return data;
  }
}

class AdditionalInformation {
  bool _suspended = false;
  bool _emailVerified = false;

  AdditionalInformation(
      {required bool suspended, required bool emailVerified}) {
    this._suspended = suspended;
    this._emailVerified = emailVerified;
  }

  bool get suspended => _suspended;

  set suspended(bool suspended) => _suspended = suspended;

  bool get emailVerified => _emailVerified;

  set emailVerified(bool emailVerified) => _emailVerified = emailVerified;

  AdditionalInformation.fromJson(Map<String, dynamic> json) {
    _suspended = json['suspended'];
    _emailVerified = json['email_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['suspended'] = this._suspended;
    data['email_verified'] = this._emailVerified;
    return data;
  }
}

class JoinedOn {
  String _date = '';
  String _time = '';

  JoinedOn({required String date, required String time}) {
    this._date = date;
    this._time = time;
  }

  String get date => _date;

  set date(String date) => _date = date;

  String get time => _time;

  set time(String time) => _time = time;

  JoinedOn.fromJson(Map<String, dynamic> json) {
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
  String _username = '';
  String _firstName = '';
  String _lastName = '';

  Slugs(
      {required String username,
      required String firstName,
      required String lastName}) {
    this._username = username;
    this._firstName = firstName;
    this._lastName = lastName;
  }

  String get username => _username;

  set username(String username) => _username = username;

  String get firstName => _firstName;

  set firstName(String firstName) => _firstName = firstName;

  String get lastName => _lastName;

  set lastName(String lastName) => _lastName = lastName;

  Slugs.fromJson(Map<String, dynamic> json) {
    _username = json['username'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this._username;
    data['first_name'] = this._firstName;
    data['last_name'] = this._lastName;
    return data;
  }
}

class Books {
  String _bookId = '';
  String _uploaderId = '';
  BookInformation _bookInformation =
      BookInformation(isbn: '', name: '', author: '', publisher: '');
  Additional_Information _additionalInformation = Additional_Information(
      description: '', condition: '', imagesCollectionId: '', images: []);
  Pricing _pricing = Pricing(originalPrice: '', sellingPrice: '');
  JoinedOn _createdOn = JoinedOn(date: '', time: '');
  Slug _slugs = Slug(name: '');
  String _location = '';

  Books(
      {required String bookId,
      required String uploaderId,
      required BookInformation bookInformation,
      required Additional_Information additionalInformation,
      required Pricing pricing,
      required JoinedOn createdOn,
      required Slug slugs,
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

  Additional_Information get additionalInformation => _additionalInformation;

  set additionalInformation(Additional_Information additionalInformation) =>
      _additionalInformation = additionalInformation;

  Pricing get pricing => _pricing;

  set pricing(Pricing pricing) => _pricing = pricing;

  JoinedOn get createdOn => _createdOn;

  set createdOn(JoinedOn createdOn) => _createdOn = createdOn;

  Slug get slugs => _slugs;

  set slugs(Slug slugs) => _slugs = slugs;

  String get location => _location;

  set location(String location) => _location = location;

  Books.fromJson(Map<String, dynamic> json) {
    _bookId = json['book_id'];
    _uploaderId = json['uploader_id'];
    _bookInformation = (json['book_information'] != null
        ? new BookInformation.fromJson(json['book_information'])
        : null)!;
    _additionalInformation = (json['additional_information'] != null
        ? new Additional_Information.fromJson(json['additional_information'])
        : null)!;
    _pricing = (json['pricing'] != null
        ? new Pricing.fromJson(json['pricing'])
        : null)!;
    _createdOn = (json['created_on'] != null
        ? new JoinedOn.fromJson(json['created_on'])
        : null)!;
    _slugs = (json['slugs'] != null ? new Slug.fromJson(json['slugs']) : null)!;
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

class Additional_Information {
  String _description = '';
  String _condition = '';
  String _imagesCollectionId = '';
  List<String> _images = [];

  Additional_Information(
      {required String description,
      required String condition,
      required String imagesCollectionId,
      required List<String> images}) {
    _description = description;
    _condition = condition;
    _imagesCollectionId = imagesCollectionId;
    _images = images;
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

  Additional_Information.fromJson(Map<String, dynamic> json) {
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

class Slug {
  String _name = '';

  Slug({required String name}) {
    _name = name;
  }

  String get name => _name;

  set name(String name) => _name = name;

  Slug.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = _name;
    return data;
  }
}
