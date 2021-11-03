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

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookology/constants/strings.constant.dart';
import 'package:bookology/constants/values.constants.dart';
import 'package:bookology/managers/dialogs.managers.dart';
import 'package:bookology/managers/toast.manager.dart';
import 'package:bookology/managers/view.manager.dart';
import 'package:bookology/models/notification.model.dart';
import 'package:bookology/models/room.model.dart';
import 'package:bookology/services/api.service.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:bookology/ui/components/collapsable_app_bar.component.dart';
import 'package:bookology/ui/widgets/error.widget.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({
    Key? key,
  }) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<NotificationModel>?> _notifications;
  final ApiService _apiService = ApiService();
  final CacheService _cacheService = CacheService();

  @override
  void initState() {
    super.initState();
    _notifications = getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CollapsableAppBar(
        title: StringConstants.navigationNotifications,
        automaticallyImplyLeading: true,
        body: FutureBuilder<List<NotificationModel>?>(
          future: _notifications,
          initialData: const [],
          builder: (BuildContext context,
              AsyncSnapshot<List<NotificationModel>?> notifications) {
            if (notifications.connectionState == ConnectionState.done) {
              if (notifications.hasData) {
                if (notifications.data!.length == 1 &&
                    notifications.data![0].metadata.senderId == 'null') {
                  return Center(
                    child: Text(
                      'No Notifications',
                      style: TextStyle(
                        color: Theme.of(context).inputDecorationTheme.fillColor,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: notifications.data!.length,
                  padding: const EdgeInsets.only(
                    top: 30,
                  ),
                  itemBuilder: (BuildContext context, index) {
                    return Container(
                      margin: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        bottom: 10,
                        top: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          ValuesConstant.borderRadius,
                        ),
                        color: Theme.of(context).cardTheme.color,
                        border: Border.all(
                          color: Colors.grey,
                          width: 0.5,
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(
                          ValuesConstant.borderRadius,
                        ),
                        onTap: () async {
                          if (!notifications.data![index].notification.seen) {
                            DialogsManager(context)
                                .acceptDiscussionRequestDialog(
                              onRequestAccepted: () async {
                                Navigator.pop(context);
                                DialogsManager(context).showProgressDialog(
                                  content: 'Creating Discussion',
                                );
                                final result = await _apiService.createRoom(
                                  room: RoomModel(
                                    bookId: notifications
                                        .data![index].metadata.bookId,
                                    notificationId: notifications
                                        .data![index].notificationId,
                                    title: notifications
                                        .data![index].notification.title,
                                    roomIcon:
                                        'https://firebasestorage.googleapis.com/v0/b/bookology-dev.appspot.com/o/SystemAssets%2Foutline_question_answer_black_24dp.png?alt=media&token=73192f36-b85b-4a6a-beba-33859b7b7a8b',
                                    users: [
                                      notifications
                                          .data![index].metadata.receiverId,
                                      notifications
                                          .data![index].metadata.senderId,
                                    ],
                                  ),
                                );
                                if (result) {
                                  Navigator.pop(context);
                                  ToastManager(context).showSuccessToast(
                                      message: 'Discussions Created');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const ViewManager(screenIndex: 2),
                                    ),
                                  );
                                } else {
                                  Navigator.pop(context);
                                  ToastManager(context).showErrorToast(
                                      message:
                                          'An Error Occurred while creating the Discussions');
                                }
                              },
                              requestText:
                                  notifications.data![index].notification.body,
                            );
                          } else {
                            ToastManager(context).showToast(
                              message: 'Request Already Accepted',
                            );
                          }
                        },
                        onLongPress: () async {
                          //DialogsManager(context).showDeleteDiscussionDialog();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 15,
                            bottom: 15,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Icon(
                                  notifications.data![index].notification.seen
                                      ? Icons.done_outlined
                                      : Icons.notifications_active_outlined,
                                  color: notifications
                                          .data![index].notification.seen
                                      ? Colors.green.shade800
                                      : Theme.of(context)
                                          .inputDecorationTheme
                                          .fillColor,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      notifications
                                          .data![index].notification.title,
                                      maxLines: 2,
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: notifications
                                                .data![index].notification.seen
                                            ? FontWeight.normal
                                            : FontWeight.bold,
                                        fontSize: 17,
                                        color: Theme.of(context)
                                            .inputDecorationTheme
                                            .fillColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    AutoSizeText(
                                      notifications
                                          .data![index].notification.body,
                                      maxLines: 2,
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .inputDecorationTheme
                                            .fillColor,
                                      ),
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
              return const Error(
                message: StringConstants.errorLoadingNotifications,
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<NotificationModel>?> getNotifications() async {
    final notifications = await _apiService.getUserNotifications();
    _cacheService.setNewNotificationNumber(count: notifications!.length);
    return notifications;
  }
}
