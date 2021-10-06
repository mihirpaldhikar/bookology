/*
 * Copyright 2021 Mihir Paldhikar
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation the
 *  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is furnished
 *  to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies
 *  or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

import 'package:bookology/models/book.model.dart';

class UserModel {
  String userId = '';
  UserInformation userInformation = UserInformation(
    username: '',
    verified: false,
    bio: '',
    profilePicture: '',
    email: '',
    firstName: '',
    lastName: '',
  );
  Providers providers = Providers(
    auth: '',
  );
  AdditionalInformation additionalInformation = AdditionalInformation(
    suspended: false,
    emailVerified: false,
  );
  JoinedOn joinedOn = JoinedOn(
    date: '',
    time: '',
  );
  Slugs slugs = Slugs(
    username: '',
    firstName: '',
    lastName: '',
  );
  List<BookModel> books = [];

  UserModel(
      {required String userId,
      required UserInformation userInformation,
      required Providers providers,
      required AdditionalInformation additionalInformation,
      required JoinedOn joinedOn,
      required Slugs slugs,
      required List<BookModel> books}) {
    userId = userId;
    userInformation = userInformation;
    providers = providers;
    additionalInformation = additionalInformation;
    joinedOn = joinedOn;
    slugs = slugs;
    books = books;
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userInformation = (json['user_information'] != null
        ? UserInformation.fromJson(json['user_information'])
        : null)!;
    providers = (json['providers'] != null
        ? Providers.fromJson(json['providers'])
        : null)!;
    additionalInformation = (json['additional_information'] != null
        ? AdditionalInformation.fromJson(json['additional_information'])
        : null)!;
    joinedOn = (json['joined_on'] != null
        ? JoinedOn.fromJson(json['joined_on'])
        : null)!;
    slugs = (json['slugs'] != null ? Slugs.fromJson(json['slugs']) : null)!;
    if (json['books'] != null) {
      books = [];
      json['books'].forEach((v) {
        books.add(BookModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_information'] = userInformation.toJson();
    data['providers'] = providers.toJson();
    data['additional_information'] = additionalInformation.toJson();
    data['joined_on'] = joinedOn.toJson();
    data['slugs'] = slugs.toJson();
    data['books'] = books.map((v) => v.toJson()).toList();
    return data;
  }
}

class UserInformation {
  String username = '';
  bool verified = false;
  String bio = '';
  String profilePicture = '';
  String email = '';
  String firstName = '';
  String lastName = '';

  UserInformation(
      {required String username,
      required bool verified,
      required String bio,
      required String profilePicture,
      required String email,
      required String firstName,
      required String lastName}) {
    username = username;
    verified = verified;
    bio = bio;
    profilePicture = profilePicture;
    email = email;
    firstName = firstName;
    lastName = lastName;
  }

  UserInformation.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    verified = json['verified'];
    bio = json['bio'];
    profilePicture = json['profile_picture'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['verified'] = verified;
    data['bio'] = bio;
    data['profile_picture'] = profilePicture;
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    return data;
  }
}

class Providers {
  String auth = '';

  Providers({required String auth}) {
    auth = auth;
  }

  Providers.fromJson(Map<String, dynamic> json) {
    auth = json['auth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['auth'] = auth;
    return data;
  }
}

class AdditionalInformation {
  bool suspended = false;
  bool emailVerified = false;

  AdditionalInformation(
      {required bool suspended, required bool emailVerified}) {
    suspended = suspended;
    emailVerified = emailVerified;
  }

  AdditionalInformation.fromJson(Map<String, dynamic> json) {
    suspended = json['suspended'];
    emailVerified = json['email_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['suspended'] = suspended;
    data['email_verified'] = emailVerified;
    return data;
  }
}

class JoinedOn {
  String date = '';
  String time = '';

  JoinedOn({required String date, required String time}) {
    date = date;
    time = time;
  }

  JoinedOn.fromJson(Map<String, dynamic> json) {
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
  String username = '';
  String firstName = '';
  String lastName = '';

  Slugs(
      {required String username,
      required String firstName,
      required String lastName}) {
    username = username;
    firstName = firstName;
    lastName = lastName;
  }

  Slugs.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    return data;
  }
}
