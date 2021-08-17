import 'dart:io';

import 'package:bookology/managers/chat_ui.manager.dart';
import 'package:bookology/managers/discussions.manager.dart';
import 'package:bookology/managers/screen.manager.dart';
import 'package:bookology/services/firestore.service.dart';
import 'package:bookology/ui/widgets/circular_image.widget.dart';
import 'package:bookology/ui/widgets/outlined_button.widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
    required this.room,
    required this.roomTitle,
    required this.userName,
    required this.isVerified,
    required this.userProfileImage,
  }) : super(key: key);

  final types.Room room;
  final String roomTitle;
  final String userName;
  final bool isVerified;
  final String userProfileImage;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isAttachmentUploading = false;
  final firestoreService = new FirestoreService(FirebaseFirestore.instance);

  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
              top: 10,
              left: 20,
              right: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 5,
                  ),
                  width: 50,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                OutLinedButton(
                  outlineColor: Theme.of(context).accentColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.image_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Photo'),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _handleImageSelection();
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                OutLinedButton(
                  outlineColor: Theme.of(context).accentColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.description_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      Text('File'),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _handleFileSelection();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final name = result.files.single.name;
      final filePath = result.files.single.path;
      final file = File(filePath ?? '');
      final collectionID =
          '${DateTime.now().minute}${DateTime.now().microsecond}${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}${DateTime.now().hashCode}';
      try {
        final reference = FirebaseStorage.instance
            .ref('rooms')
            .child(widget.room.id)
            .child('documents')
            .child(collectionID)
            .child(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialFile(
          mimeType: lookupMimeType(filePath ?? ''),
          name: name,
          size: result.files.single.size,
          uri: uri,
        );

        firestoreService.sendMessage(message, widget.room.id, collectionID);
        _setAttachmentUploading(false);
      } on FirebaseException catch (e) {
        _setAttachmentUploading(false);
        print(e);
      }
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().getImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = DateTime.now().microsecond.toString();
      final collectionID =
          '${DateTime.now().minute}${DateTime.now().microsecond}${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}${DateTime.now().hashCode}';

      try {
        final reference = FirebaseStorage.instance
            .ref('rooms')
            .child(widget.room.id)
            .child('images')
            .child(collectionID)
            .child(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialImage(
          height: image.height.toDouble(),
          name: name,
          size: size,
          uri: uri,
          width: image.width.toDouble(),
        );

        firestoreService.sendMessage(message, widget.room.id, collectionID);
        _setAttachmentUploading(false);
      } on FirebaseException catch (e) {
        _setAttachmentUploading(false);
        print(e);
      }
    }
  }

  void _handleMessageTap(types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        final client = http.Client();
        final request = await client.get(Uri.parse(message.uri));
        final bytes = request.bodyBytes;
        final documentsDir = (await getApplicationDocumentsDirectory()).path;
        localPath = '$documentsDir/${message.name}';

        if (!File(localPath).existsSync()) {
          final file = File(localPath);
          await file.writeAsBytes(bytes);
        }
      }

      await OpenFile.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    FirebaseChatCore.instance.updateMessage(updatedMessage, widget.room.id);
  }

  void _handleSendPressed(types.PartialText message) {
    firestoreService.sendMessage(message, widget.room.id,
        '${DateTime.now().minute}${DateTime.now().microsecond}${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}${DateTime.now().hashCode}');
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircularImage(
              image: widget.userProfileImage,
              radius: 35,
            ),
            SizedBox(
              width: 18,
            ),
            Text(
              widget.userName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Visibility(
              visible: widget.isVerified,
              child: Icon(
                Icons.verified,
                color: Colors.blue,
                size: 20,
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          Tooltip(
            message: 'Connection is Secured',
            child: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Row(
                            children: [
                              Icon(
                                Icons.lock_outlined,
                                color: Colors.green,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Secured Connection',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          content: Container(
                            height: 180,
                            child: Column(
                              children: [
                                Text(
                                  'This discussion is end-to-end secured. '
                                  'No one even Bookology can read the ongoing '
                                  'discussions.',
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                OutLinedButton(
                                  child: Center(child: Text('OK')),
                                  outlineColor: Colors.green,
                                  backgroundColor: Colors.green[100],
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ));
              },
              icon: Icon(
                Icons.lock_outlined,
                color: Colors.green,
              ),
            ),
          ),
          PopupMenuButton(
            onSelected: menuAction,
            itemBuilder: (BuildContext itemBuilder) => {
              'Delete Discussions',
            }
                .map(
                  (value) => PopupMenuItem(
                    child: Text(value),
                    value: value,
                  ),
                )
                .toList(),
          )
        ],
      ),
      body: StreamBuilder<types.Room>(
        initialData: widget.room,
        stream: FirebaseChatCore.instance.room(widget.room.id),
        builder: (context, snapshot) {
          return StreamBuilder<List<types.Message>>(
            initialData: const [],
            stream: FirebaseChatCore.instance.messages(snapshot.data!),
            builder: (context, snapshot) {
              return Discussions(
                showUserAvatars: true,
                showUserNames: false,
                usePreviewData: true,
                theme: ChatUiManager(),
                isAttachmentUploading: _isAttachmentUploading,
                messages: snapshot.data ?? [],
                onAttachmentPressed: _handleAtachmentPressed,
                onMessageTap: _handleMessageTap,
                onMessageLongPress: (value) async {
                  if (FirebaseAuth.instance.currentUser!.uid ==
                      value.author.id) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Row(
                          children: [
                            Icon(
                              Icons.auto_delete_outlined,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Unsend Message?',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        content: Container(
                          height: 200,
                          child: Column(
                            children: [
                              Text(
                                'You will be able to unsend the message '
                                'you have sent.',
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              OutLinedButton(
                                child: Center(child: Text('Unsend')),
                                outlineColor: Colors.red,
                                backgroundColor: Colors.red[100],
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  await firestoreService.unsendMessage(
                                    messageID: value.id,
                                    mediaURL: value.toJson()['uri'] == null
                                        ? ''
                                        : value.toJson()['uri'],
                                    roomID: value.roomId as String,
                                    messageType: value.type.toString(),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              OutLinedButton(
                                child: Center(child: Text('Cancel')),
                                outlineColor: Theme.of(context).accentColor,
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
                onPreviewDataFetched: _handlePreviewDataFetched,
                onSendPressed: _handleSendPressed,
                user: types.User(
                  id: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget chatMsg(Message message) {
    return Text(message.message.toString());
  }

  void menuAction(String value) {
    switch (value) {
      case 'Delete Discussions':
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Row(
                    children: [
                      Icon(
                        Icons.delete_forever_outlined,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Delete Discussion?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  content: Container(
                    height: 260,
                    child: Column(
                      children: [
                        Text(
                          'This will delete the discussion for both'
                          ' the users. This action is '
                          'irreversible & you will need to request '
                          'the uploader to start discussion '
                          'again.'
                          '.',
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        OutLinedButton(
                          child: Center(child: Text('Delete')),
                          outlineColor: Colors.red,
                          backgroundColor: Colors.red[100],
                          onPressed: () async {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ScreenManager(currentIndex: 1)),
                              (route) => false,
                            );
                            await firestoreService.deleteDiscussionRoom(
                                discussionRoomID: widget.room.id);
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        OutLinedButton(
                          child: Center(child: Text('Cancel')),
                          outlineColor: Theme.of(context).accentColor,
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                ));

        break;
    }
  }
}