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
  String senderId = '';
  String receiverId = '';
  String notificationTitle = '';
  String notificationBody = '';
  String notificationType = '';
  CreatedOn createdOn = CreatedOn(
    date: '',
    time: '',
  );

  NotificationModel(
      {required String senderId,
      required String receiverId,
      required String notificationTitle,
      required String notificationBody,
      required String notificationType,
      required CreatedOn createdOn}) {
    senderId = senderId;
    receiverId = receiverId;
    notificationTitle = notificationTitle;
    notificationBody = notificationBody;
    notificationType = notificationType;
    createdOn = createdOn;
  }

  NotificationModel.fromJson(Map<String, dynamic> json) {
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    notificationTitle = json['notification_title'];
    notificationBody = json['notification_body'];
    notificationType = json['notification_type'];
    createdOn = (json['created_on'] != null
        ? CreatedOn.fromJson(json['created_on'])
        : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sender_id'] = senderId;
    data['receiver_id'] = receiverId;
    data['notification_title'] = notificationTitle;
    data['notification_body'] = notificationBody;
    data['notification_type'] = notificationType;
    data['created_on'] = createdOn.toJson();
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
