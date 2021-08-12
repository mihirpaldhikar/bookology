import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookology/services/firestore.service.dart';
import 'package:bookology/ui/screens/chat.screen.dart';
import 'package:bookology/ui/widgets/outlined_button.widget.dart';
import 'package:bookology/utils/utils.dart';
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
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: color,
        backgroundImage: hasImage ? NetworkImage(room.imageUrl!) : null,
        radius: 30,
        child: !hasImage
            ? Text(
                name.isEmpty ? '' : name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              )
            : null,
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
                            room: room,
                            roomTitle: groupOwner,
                          ),
                        ),
                      );
                    },
                    onLongPress: () async {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text('Delete Discussion?'),
                                content: Text(
                                    'This will delete the discussion for both'
                                    ' the users. This action is '
                                    'irreversible & you will need to request '
                                    'the uploader to start discussion '
                                    'again.'
                                    '.'),
                                actions: [
                                  OutLinedButton(
                                    child: Text('Delete'),
                                    outlineColor: Theme.of(context).accentColor,
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      await firestoreService
                                          .deleteDiscussionRoom(
                                              discussionRoomID: room.id);
                                    },
                                  ),
                                  OutLinedButton(
                                    child: Text('Cancel'),
                                    outlineColor: Theme.of(context).accentColor,
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ));
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  Text(
                                    'You, $groupOwner',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  )
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
}
