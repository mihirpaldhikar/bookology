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

class NotificationModel {
  String notificationId = '';
  Metadata metadata = Metadata(senderId: '', receiverId: '', bookId: '');
  Notification notification = Notification(
    type: '',
    body: '',
    title: '',
    seen: false,
  );
  CreatedOn createdOn = CreatedOn(
    time: '',
    date: '',
  );

  NotificationModel({
    required this.notificationId,
    required this.metadata,
    required this.notification,
    required this.createdOn,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    notificationId = json['notification_id'];
    metadata = (json['metadata'] != null
        ? Metadata.fromJson(json['metadata'])
        : null)!;
    notification = (json['notification'] != null
        ? Notification.fromJson(json['notification'])
        : null)!;
    createdOn = (json['created_on'] != null
        ? CreatedOn.fromJson(json['created_on'])
        : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notification_id'] = notificationId;
    data['metadata'] = metadata.toJson();
    data['notification'] = notification.toJson();
    data['created_on'] = createdOn.toJson();
    return data;
  }
}

class Metadata {
  String senderId = '';
  String receiverId = '';
  String bookId = '';

  Metadata({
    required this.senderId,
    required this.receiverId,
    required this.bookId,
  });

  Metadata.fromJson(Map<String, dynamic> json) {
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    bookId = json['book_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sender_id'] = senderId;
    data['receiver_id'] = receiverId;
    data['book_id'] = bookId;
    return data;
  }
}

class Notification {
  String title = '';
  String body = '';
  String type = '';
  bool seen = false;

  Notification({
    required this.title,
    required this.body,
    required this.type,
    required this.seen,
  });

  Notification.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    type = json['type'];
    seen = json['seen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['body'] = body;
    data['type'] = type;
    data['seen'] = seen;
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
