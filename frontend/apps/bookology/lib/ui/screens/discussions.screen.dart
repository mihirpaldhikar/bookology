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

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookology/constants/colors.constant.dart';
import 'package:bookology/constants/strings.constant.dart';
import 'package:bookology/constants/values.constants.dart';
import 'package:bookology/enums/connectivity.enum.dart';
import 'package:bookology/managers/dialogs.managers.dart';
import 'package:bookology/services/connectivity.service.dart';
import 'package:bookology/ui/components/collapsable_app_bar.component.dart';
import 'package:bookology/ui/screens/chat.screen.dart';
import 'package:bookology/ui/screens/offline.screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class DiscussionsScreen extends StatefulWidget {
  final AdaptiveThemeMode themeMode;

  const DiscussionsScreen({
    Key? key,
    required this.themeMode,
  }) : super(key: key);

  @override
  _DiscussionsScreenState createState() => _DiscussionsScreenState();
}

class _DiscussionsScreenState extends State<DiscussionsScreen> {
  bool _error = false;
  bool _initialized = false;
  String _groupOwner = '';
  String _userName = '';
  String _userImageProfile = '';
  bool _isVerified = false;

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        setState(() {});
      });
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  Widget _buildAvatar(types.Room room) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(right: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius:
              BorderRadius.circular(ValuesConstant.secondaryBorderRadius),
        ),
        child: Icon(
          Icons.people_outlined,
          size: 40,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Container();
    }

    if (!_initialized) {
      return Container();
    }
    return StreamBuilder<ConnectivityStatus>(
      initialData: ConnectivityStatus.cellular,
      stream: ConnectivityService().connectionStatusController.stream,
      builder:
          (BuildContext context, AsyncSnapshot<ConnectivityStatus> snapshot) {
        if (snapshot.data == ConnectivityStatus.offline) {
          return offlineScreen(context: context);
        } else {
          return Scaffold(
            // appBar: AppBar(
            //   title: Text(
            //     StringConstants.navigationDiscussions,
            //     style: Theme.of(context).appBarTheme.titleTextStyle,
            //   ),
            //   automaticallyImplyLeading: false,
            // ),
            body: CollapsableAppBar(
              title: StringConstants.navigationDiscussions,
              automaticallyImplyLeading: false,
              body: StreamBuilder<List<types.Room>>(
                stream: FirebaseChatCore.instance.rooms(
                  orderByUpdatedAt: true,
                ),
                initialData: const [],
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/svg/chats.svg',
                            width: 100,
                            height: 200,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            StringConstants.wordNoDiscussions,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            StringConstants.sentenceEmptyDiscussion,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      final room = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 17,
                          right: 17,
                        ),
                        child: Slidable(
                          secondaryActions: [
                            IconSlideAction(
                              color: Colors.transparent,
                              iconWidget: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color:
                                      ColorsConstant.lightDangerBackgroundColor,
                                  borderRadius: BorderRadius.circular(
                                      ValuesConstant.secondaryBorderRadius),
                                ),
                                child: Icon(
                                  Icons.delete_forever,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                              onTap: () {
                                DialogsManager(context)
                                    .showDeleteDiscussionDialog(room);
                              },
                            ),
                          ],
                          actionPane: const SlidableBehindActionPane(),
                          child: Card(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardTheme.color,
                                borderRadius: BorderRadius.circular(
                                    ValuesConstant.borderRadius),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(
                                    ValuesConstant.borderRadius),
                                onTap: () {
                                  for (var element in room.users) {
                                    if (element.id.toString() !=
                                        FirebaseAuth.instance.currentUser!.uid
                                            .toString()) {
                                      setState(() {
                                        _groupOwner =
                                            '${element.firstName.toString()} ${element.lastName}';
                                        _userName =
                                            element.metadata!['userName'];
                                        _isVerified =
                                            element.metadata!['isVerified'];
                                        _userImageProfile = element.imageUrl!;
                                      });
                                    }
                                  }
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                        isVerified: _isVerified,
                                        userName: _userName,
                                        room: room,
                                        roomTitle: _groupOwner,
                                        userProfileImage: _userImageProfile,
                                      ),
                                    ),
                                  );
                                },
                                onLongPress: () async {
                                  DialogsManager(context)
                                      .showDeleteDiscussionDialog(room);
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    bottom: 10,
                                    top: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      _buildAvatar(room),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Wrap(
                                              children: [
                                                AutoSizeText(
                                                  room.name ?? 'No Name',
                                                  maxLines: 2,
                                                  softWrap: false,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .inputDecorationTheme
                                                        .fillColor,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                right: 5,
                                                top: 5,
                                              ),
                                              child: Text(
                                                discussionLastUpdatedAt(
                                                  context,
                                                  DateTime
                                                      .fromMicrosecondsSinceEpoch(
                                                          room.updatedAt! *
                                                              1000),
                                                  DateTime.now(),
                                                ),
                                                style: TextStyle(
                                                  color: widget.themeMode ==
                                                          AdaptiveThemeMode.dark
                                                      ? const Color(0xffc9c3c3)
                                                      : Colors.grey.shade600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}

String discussionLastUpdatedAt(
    BuildContext context, DateTime from, DateTime to) {
  if (from.day == to.day && from.month == to.month && from.year == to.year) {
    return MediaQuery.of(context).alwaysUse24HourFormat
        ? DateFormat('HH:mm').format(from).toString()
        : DateFormat('hh:mm').format(from).toString();
  }
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  if ((to.difference(from).inHours / 24).round() == 1) {
    return '${(to.difference(from).inHours / 24).round()} day ago';
  }
  return '${(to.difference(from).inHours / 24).round()} days ago';
}
