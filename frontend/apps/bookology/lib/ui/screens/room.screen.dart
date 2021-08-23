import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookology/enums/connectivity.enum.dart';
import 'package:bookology/managers/dialogs.managers.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/connectivity.service.dart';
import 'package:bookology/services/firestore.service.dart';
import 'package:bookology/ui/screens/chat.screen.dart';
import 'package:bookology/ui/screens/offline.screen.dart';
import 'package:bookology/ui/widgets/circular_image.widget.dart';
import 'package:bookology/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({Key? key}) : super(key: key);

  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  bool _error = false;
  bool _initialized = false;
  User? _user;
  String groupOwner = '';
  String userName = '';
  String userImageProfile = '';
  bool isVerified = false;
  final authService = new AuthService(FirebaseAuth.instance);
  final firestoreService = new FirestoreService(FirebaseFirestore.instance);

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        setState(() {
          _user = user;
        });
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
    var color = Colors.white;

    if (room.type == types.RoomType.direct) {
      try {
        final otherUser = room.users.firstWhere(
          (u) => u.id != _user!.uid,
        );

        color = getUserAvatarNameColor(otherUser);
      } catch (e) {
        // Do nothing if other user is not found
      }
    }

    final hasImage = room.imageUrl != null;
    final name = room.name ?? '';

    return Container(
      width: 80,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(right: 16),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(
              room.imageUrl!,
            ),
          ),
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
      initialData: ConnectivityStatus.Cellular,
      stream: ConnectivityService().connectionStatusController.stream,
      builder:
          (BuildContext context, AsyncSnapshot<ConnectivityStatus> snapshot) {
        if (snapshot.data == ConnectivityStatus.Offline) {
          return OfflineScreen();
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Discussions',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              automaticallyImplyLeading: false,
            ),
            body: StreamBuilder<List<types.Room>>(
              stream: FirebaseChatCore.instance.rooms(),
              initialData: const [],
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(
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
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'No Discussions',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'To Start a discussion, request book uploader to allow '
                          'enquiry of the book.',
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

                return Container(
                  margin: EdgeInsets.only(
                    top: 40,
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final room = snapshot.data![index];
                      room.users.forEach((element) {
                        if (element.id.toString() !=
                            FirebaseAuth.instance.currentUser!.uid.toString()) {
                          groupOwner =
                              '${element.firstName.toString()} ${element.lastName}';
                          userName = element.metadata!['userName'];
                          isVerified = element.metadata!['isVerified'];
                          userImageProfile = element.imageUrl!;
                        }
                      });
                      return Container(
                        margin: EdgeInsets.only(
                          left: 10,
                          right: 10,
                          bottom: 30,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  isVerified: isVerified,
                                  userName: userName,
                                  room: room,
                                  roomTitle: groupOwner,
                                  userProfileImage: userImageProfile,
                                ),
                              ),
                            );
                          },
                          onLongPress: () async {
                            DialogsManager(context)
                                .showDeleteDiscussionDialog(room);
                          },
                          child: Container(
                            width: 200,
                            padding: EdgeInsets.only(
                              left: 20,
                              bottom: 20,
                              top: 20,
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
                                        AutoSizeText(
                                          room.name ?? 'No Book Name',
                                          maxLines: 2,
                                          softWrap: false,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Chip(
                                              label: Text(
                                                'You',
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                ),
                                              ),
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              avatar: CircularImage(
                                                image: authService
                                                    .currentUser()!
                                                    .photoURL
                                                    .toString(),
                                                radius: 25,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Chip(
                                              label: Text(
                                                '$groupOwner',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  color: Colors.black,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              avatar: CircularImage(
                                                image: userImageProfile,
                                                radius: 25,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
