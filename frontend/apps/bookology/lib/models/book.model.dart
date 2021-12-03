class BookModel {
  String bookId = 'Nil Book ID';
  BookInformation bookInformation = BookInformation(
    isbn: '',
    name: '',
    author: '',
    publisher: '',
  );
  AdditionalInformation additionalInformation = AdditionalInformation(
    description: '',
    condition: '',
    categories: [],
    imagesCollectionId: '',
    images: [],
  );
  Pricing pricing = Pricing(
    originalPrice: '',
    sellingPrice: '',
    currency: '',
  );
  CreatedOn createdOn = CreatedOn(
    date: '',
    time: '',
  );
  Slugs slugs = Slugs(
    name: '',
  );
  Uploader uploader = Uploader(
    userId: '',
    username: '',
    verified: false,
    profilePictureUrl: '',
    firstName: '',
    lastName: '',
  );
  String location = '';

  BookModel({
    required this.bookId,
    required this.bookInformation,
    required this.additionalInformation,
    required this.pricing,
    required this.createdOn,
    required this.slugs,
    required this.uploader,
    required this.location,
  });

  BookModel.fromJson(Map<String, dynamic> json) {
    bookId = json['book_id'];
    bookInformation = (json['book_information'] != null
        ? BookInformation.fromJson(json['book_information'])
        : null)!;
    additionalInformation = (json['additional_information'] != null
        ? AdditionalInformation.fromJson(json['additional_information'])
        : null)!;
    pricing =
        (json['pricing'] != null ? Pricing.fromJson(json['pricing']) : null)!;
    createdOn = (json['created_on'] != null
        ? CreatedOn.fromJson(json['created_on'])
        : null)!;
    slugs = (json['slugs'] != null ? Slugs.fromJson(json['slugs']) : null)!;
    uploader = (json['uploader'] != null
        ? Uploader.fromJson(json['uploader'])
        : null)!;
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['book_id'] = bookId;
    data['book_information'] = bookInformation.toJson();
    data['additional_information'] = additionalInformation.toJson();
    data['pricing'] = pricing.toJson();
    data['created_on'] = createdOn.toJson();
    data['slugs'] = slugs.toJson();
    data['uploader'] = uploader.toJson();
    data['location'] = location;
    return data;
  }
}

class BookInformation {
  String isbn = '';
  String name = '';
  String author = '';
  String publisher = '';

  BookInformation({
    required this.isbn,
    required this.name,
    required this.author,
    required this.publisher,
  });

  BookInformation.fromJson(Map<String, dynamic> json) {
    isbn = json['isbn'];
    name = json['name'];
    author = json['author'];
    publisher = json['publisher'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isbn'] = isbn;
    data['name'] = name;
    data['author'] = author;
    data['publisher'] = publisher;
    return data;
  }
}

class AdditionalInformation {
  String description = '';
  String condition = '';
  List<dynamic> categories = [];
  String imagesCollectionId = '';
  List<String> images = [];

  AdditionalInformation({
    required this.description,
    required this.condition,
    required this.categories,
    required this.imagesCollectionId,
    required this.images,
  });

  AdditionalInformation.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    condition = json['condition'];
    categories = json['categories'].cast<dynamic>();
    imagesCollectionId = json['images_collection_id'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['condition'] = condition;
    data['categories'] = categories;
    data['images_collection_id'] = imagesCollectionId;
    data['images'] = images;
    return data;
  }
}

class Pricing {
  String originalPrice = '';
  String sellingPrice = '';
  String currency = '';

  Pricing({
    required this.originalPrice,
    required this.sellingPrice,
    required this.currency,
  });

  Pricing.fromJson(Map<String, dynamic> json) {
    originalPrice = json['original_price'];
    sellingPrice = json['selling_price'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['original_price'] = originalPrice;
    data['selling_price'] = sellingPrice;
    data['currency'] = currency;
    return data;
  }
}

class CreatedOn {
  String date = '';
  String time = '';

  CreatedOn({
    required this.date,
    required this.time,
  });

  CreatedOn.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['time'] = time;
    return data;
  }
}

class Slugs {
  late String name;

  Slugs({
    required this.name,
  });

  Slugs.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}

class Uploader {
  String userId = '';
  String username = '';
  bool verified = false;
  String profilePictureUrl = '';
  String firstName = '';
  String lastName = '';

  Uploader({
    required this.userId,
    required this.username,
    required this.verified,
    required this.profilePictureUrl,
    required this.firstName,
    required this.lastName,
  });

  Uploader.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    username = json['username'];
    verified = json['verified'];
    profilePictureUrl = json['profile_picture_url'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['username'] = username;
    data['verified'] = verified;
    data['profile_picture_url'] = profilePictureUrl;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    return data;
  }
}
