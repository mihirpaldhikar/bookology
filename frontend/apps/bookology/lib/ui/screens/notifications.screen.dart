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

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookology/constants/colors.constant.dart';
import 'package:bookology/constants/strings.constant.dart';
import 'package:bookology/constants/values.constants.dart';
import 'package:bookology/models/notification.model.dart';
import 'package:bookology/services/api.service.dart';
import 'package:bookology/services/cache.service.dart';
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
  late Future<List<NotificationModel>?> notifications;
  final ApiService apiService = ApiService();
  final CacheService cacheService = CacheService();

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
          StringConstants.navigationNotifications,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder<List<NotificationModel>?>(
        future: notifications,
        initialData: const [],
        builder: (BuildContext context,
            AsyncSnapshot<List<NotificationModel>?> notifications) {
          if (notifications.connectionState == ConnectionState.done) {
            if (notifications.hasData) {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
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
                      border: Border.all(
                        color: Colors.grey.shade600,
                        width: 1.5,
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(
                        ValuesConstant.borderRadius,
                      ),
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
                                    notifications.data![index].notification.seen
                                        ? Colors.green.shade50
                                        : ColorsConstant.secondaryColor,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Icon(
                                notifications.data![index].notification.seen
                                    ? Icons.done_outlined
                                    : Icons.notifications_active_outlined,
                                color: notifications
                                        .data![index].notification.seen
                                    ? Colors.green.shade800
                                    : Theme.of(context).colorScheme.secondary,
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
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
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
    );
  }

  Future<List<NotificationModel>?> getNotifications() async {
    final notifications = await apiService.getUserNotifications();
    cacheService.setNewNotificationNumber(count: notifications!.length);
    return notifications;
  }
}
