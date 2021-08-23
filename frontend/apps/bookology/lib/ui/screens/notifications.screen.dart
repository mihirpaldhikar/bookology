import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookology/constants/colors.constant.dart';
import 'package:bookology/constants/values.constants.dart';
import 'package:bookology/models/notification.model.dart';
import 'package:bookology/services/api.service.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<NotificationModel>?> notifications;
  final ApiService apiService = new ApiService();
  final CacheService cacheService = new CacheService();

  @override
  void initState() {
    super.initState();
    notifications = getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<NotificationModel>?>(
        future: notifications,
        initialData: [],
        builder: (BuildContext context,
            AsyncSnapshot<List<NotificationModel>?> notifications) {
          if (notifications.connectionState == ConnectionState.done) {
            if (notifications.hasData) {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                itemCount: notifications.data!.length,
                itemBuilder: (BuildContext context, index) {
                  return Container(
                    margin: EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: 10,
                      top: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(ValuesConstant.BORDER_RADIUS),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: InkWell(
                      borderRadius:
                          BorderRadius.circular(ValuesConstant.BORDER_RADIUS),
                      onLongPress: () async {
                        //DialogsManager(context).showDeleteDiscussionDialog();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 5,
                          bottom: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: ColorsConstant.SECONDARY_COLOR,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Icon(
                                Icons.notifications_outlined,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(
                                    notifications
                                        .data![index].notificationTitle,
                                    maxLines: 2,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  AutoSizeText(
                                    notifications.data![index].notificationBody,
                                    maxLines: 2,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return Text('An error occurred');
          } else {
            return Text('Loading');
          }
        },
      ),
    );
  }

  Future<List<NotificationModel>?> getNotifications() async {
    final notifications = await apiService.getUserNotifications();
    cacheService.setNewNotificationNumber(count: notifications!.length);
    return notifications;
  }
}
