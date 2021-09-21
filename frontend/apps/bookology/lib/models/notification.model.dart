class NotificationModel {
  Metadata metadata = Metadata(
    receiverId: '',
    senderId: '',
  );
  Notification notification = Notification(
    title: '',
    body: '',
    type: '',
    seen: false,
  );
  CreatedOn createdOn = CreatedOn(
    date: '',
    time: '',
  );

  NotificationModel({
    required this.metadata,
    required this.notification,
    required this.createdOn,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
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
    data['metadata'] = metadata.toJson();
    data['notification'] = notification.toJson();
    data['created_on'] = createdOn.toJson();
    return data;
  }
}

class Metadata {
  String senderId = '';
  String receiverId = '';

  Metadata({
    required this.senderId,
    required this.receiverId,
  });

  Metadata.fromJson(Map<String, dynamic> json) {
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sender_id'] = senderId;
    data['receiver_id'] = receiverId;
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
