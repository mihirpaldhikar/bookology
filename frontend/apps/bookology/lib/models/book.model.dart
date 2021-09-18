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

class BookModel {
  String bookId = '';
  String uploaderId = '';
  BookInformation bookInformation = BookInformation(
    isbn: '',
    name: '',
    author: '',
    publisher: '',
  );
  AdditionalInformation additionalInformation = AdditionalInformation(
    description: '',
    condition: '',
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
  String location = '';

  BookModel(
      {required String bookId,
      required String uploaderId,
      required BookInformation bookInformation,
      required AdditionalInformation additionalInformation,
      required Pricing pricing,
      required CreatedOn createdOn,
      required Slugs slugs,
      required String location}) {
    bookId = bookId;
    uploaderId = uploaderId;
    bookInformation = bookInformation;
    additionalInformation = additionalInformation;
    pricing = pricing;
    createdOn = createdOn;
    slugs = slugs;
    location = location;
  }

  BookModel.fromJson(Map<String, dynamic> json) {
    bookId = json['book_id'];
    uploaderId = json['uploader_id'];
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
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['book_id'] = bookId;
    data['uploader_id'] = uploaderId;
    data['book_information'] = bookInformation.toJson();
    data['additional_information'] = additionalInformation.toJson();
    data['pricing'] = pricing.toJson();
    data['created_on'] = createdOn.toJson();
    data['slugs'] = slugs.toJson();
    data['location'] = location;
    return data;
  }
}

class BookInformation {
  String isbn = '';
  String name = '';
  String author = '';
  String publisher = '';

  BookInformation(
      {required String isbn,
      required String name,
      required String author,
      required String publisher}) {
    isbn = isbn;
    name = name;
    author = author;
    publisher = publisher;
  }

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
  String imagesCollectionId = '';
  List<String> images = [];

  AdditionalInformation(
      {required String description,
      required String condition,
      required String imagesCollectionId,
      required List<String> images}) {
    description = description;
    condition = condition;
    imagesCollectionId = imagesCollectionId;
    images = images;
  }

  AdditionalInformation.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    condition = json['condition'];
    imagesCollectionId = json['images_collection_id'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['condition'] = condition;
    data['images_collection_id'] = imagesCollectionId;
    data['images'] = images;
    return data;
  }
}

class Pricing {
  String originalPrice = '';
  String sellingPrice = '';
  String currency = '';

  Pricing(
      {required String originalPrice,
      required String sellingPrice,
      required String currency}) {
    originalPrice = originalPrice;
    sellingPrice = sellingPrice;
    currency = currency;
  }

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

  CreatedOn({required String date, required String time}) {
    date = date;
    time = time;
  }

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
  String name = '';

  Slugs({required String name}) {
    name = name;
  }

  Slugs.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}
