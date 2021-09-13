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
    this.userId = userId;
    this.userInformation = userInformation;
    this.providers = providers;
    this.additionalInformation = additionalInformation;
    this.joinedOn = joinedOn;
    this.slugs = slugs;
    this.books = books;
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userInformation = (json['user_information'] != null
        ? new UserInformation.fromJson(json['user_information'])
        : null)!;
    providers = (json['providers'] != null
        ? new Providers.fromJson(json['providers'])
        : null)!;
    additionalInformation = (json['additional_information'] != null
        ? new AdditionalInformation.fromJson(json['additional_information'])
        : null)!;
    joinedOn = (json['joined_on'] != null
        ? new JoinedOn.fromJson(json['joined_on'])
        : null)!;
    slugs = (json['slugs'] != null ? new Slugs.fromJson(json['slugs']) : null)!;
    if (json['books'] != null) {
      books = [];
      json['books'].forEach((v) {
        books.add(new BookModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_information'] = this.userInformation.toJson();
    data['providers'] = this.providers.toJson();
    data['additional_information'] = this.additionalInformation.toJson();
    data['joined_on'] = this.joinedOn.toJson();
    data['slugs'] = this.slugs.toJson();
    data['books'] = this.books.map((v) => v.toJson()).toList();
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
    this.username = username;
    this.verified = verified;
    this.bio = bio;
    this.profilePicture = profilePicture;
    this.email = email;
    this.firstName = firstName;
    this.lastName = lastName;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['verified'] = this.verified;
    data['bio'] = this.bio;
    data['profile_picture'] = this.profilePicture;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    return data;
  }
}

class Providers {
  String auth = '';

  Providers({required String auth}) {
    this.auth = auth;
  }

  Providers.fromJson(Map<String, dynamic> json) {
    auth = json['auth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['auth'] = this.auth;
    return data;
  }
}

class AdditionalInformation {
  bool suspended = false;
  bool emailVerified = false;

  AdditionalInformation(
      {required bool suspended, required bool emailVerified}) {
    this.suspended = suspended;
    this.emailVerified = emailVerified;
  }

  AdditionalInformation.fromJson(Map<String, dynamic> json) {
    suspended = json['suspended'];
    emailVerified = json['email_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['suspended'] = this.suspended;
    data['email_verified'] = this.emailVerified;
    return data;
  }
}

class JoinedOn {
  String date = '';
  String time = '';

  JoinedOn({required String date, required String time}) {
    this.date = date;
    this.time = time;
  }

  JoinedOn.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['time'] = this.time;
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
    this.username = username;
    this.firstName = firstName;
    this.lastName = lastName;
  }

  Slugs.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    return data;
  }
}
