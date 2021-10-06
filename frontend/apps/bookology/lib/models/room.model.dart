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

class RoomModel {
  String bookId = '';
  String notificationId = '';
  String title = '';
  String roomIcon = '';
  String date = '';
  String time = '';
  List<String> users = [];

  RoomModel({
    required this.bookId,
    required this.notificationId,
    required this.title,
    required this.roomIcon,
    required this.date,
    required this.time,
    required this.users,
  });

  RoomModel.fromJson(Map<String, dynamic> json) {
    bookId = json['book_id'];
    notificationId = json['notification_id'];
    title = json['title'];
    roomIcon = json['room_icon'];
    date = json['date'];
    time = json['time'];
    users = json['users'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['book_id'] = bookId;
    data['notification_id'] = notificationId;
    data['title'] = title;
    data['room_icon'] = roomIcon;
    data['date'] = date;
    data['time'] = time;
    data['users'] = users;
    return data;
  }
}
