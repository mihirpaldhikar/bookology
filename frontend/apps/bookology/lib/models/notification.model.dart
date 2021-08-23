class NotificationModel {
  String _senderId = '';
  String _receiverId = '';
  String _notificationTitle = '';
  String _notificationBody = '';
  String _notificationType = '';
  CreatedOn _createdOn = CreatedOn(
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
    this._senderId = senderId;
    this._receiverId = receiverId;
    this._notificationTitle = notificationTitle;
    this._notificationBody = notificationBody;
    this._notificationType = notificationType;
    this._createdOn = createdOn;
  }

  String get senderId => _senderId;

  set senderId(String senderId) => _senderId = senderId;

  String get receiverId => _receiverId;

  set receiverId(String receiverId) => _receiverId = receiverId;

  String get notificationTitle => _notificationTitle;

  set notificationTitle(String notificationTitle) =>
      _notificationTitle = notificationTitle;

  String get notificationBody => _notificationBody;

  set notificationBody(String notificationBody) =>
      _notificationBody = notificationBody;

  String get notificationType => _notificationType;

  set notificationType(String notificationType) =>
      _notificationType = notificationType;

  CreatedOn get createdOn => _createdOn;

  set createdOn(CreatedOn createdOn) => _createdOn = createdOn;

  NotificationModel.fromJson(Map<String, dynamic> json) {
    _senderId = json['sender_id'];
    _receiverId = json['receiver_id'];
    _notificationTitle = json['notification_title'];
    _notificationBody = json['notification_body'];
    _notificationType = json['notification_type'];
    _createdOn = (json['created_on'] != null
        ? new CreatedOn.fromJson(json['created_on'])
        : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sender_id'] = this._senderId;
    data['receiver_id'] = this._receiverId;
    data['notification_title'] = this._notificationTitle;
    data['notification_body'] = this._notificationBody;
    data['notification_type'] = this._notificationType;
    if (this._createdOn != null) {
      data['created_on'] = this._createdOn.toJson();
    }
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
