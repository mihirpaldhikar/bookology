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

import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookology/constants/strings.constant.dart';
import 'package:bookology/managers/bottom_sheet.manager.dart';
import 'package:bookology/managers/chat_ui.manager.dart';
import 'package:bookology/managers/dialogs.managers.dart';
import 'package:bookology/managers/dicsussions_input.manager.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/firestore.service.dart';
import 'package:bookology/ui/widgets/circular_image.widget.dart';
import 'package:bookology/ui/widgets/marquee.widget.dart';
import 'package:bubble/bubble.dart';
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
  final _firestoreService = FirestoreService(FirebaseFirestore.instance);
  final _authService = AuthService(FirebaseAuth.instance);

  void _handleAttachmentPressed() {
    BottomSheetManager(context).filePickerBottomSheet(onImagePressed: () {
      Navigator.pop(context);
      _handleImageSelection();
    }, onFilePressed: () {
      Navigator.pop(context);
      _handleFileSelection();
    });
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', '.html', '.zip'],
    );

    if (result != null) {
      DialogsManager(context).showSendAttachmentDialog(
          attachmentName: result.files.single.name,
          receiverName: widget.userName,
          onSendClicked: () async {
            Navigator.of(context).pop();
            _setAttachmentUploading(true);
            final name = result.files.single.name;
            final filePath = result.files.single.path;
            final file = File(filePath!);
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
                mimeType: lookupMimeType(filePath),
                name: name,
                size: result.files.single.size,
                uri: uri,
              );

              _firestoreService.sendMessage(
                  message, widget.room.id, collectionID);
              _setAttachmentUploading(false);
            } on FirebaseException {
              _setAttachmentUploading(false);
              rethrow;
            }
          });
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      DialogsManager(context).showSendAttachmentDialog(
          attachmentName: result.name,
          receiverName: widget.userName,
          onSendClicked: () async {
            Navigator.of(context).pop();
            _setAttachmentUploading(true);
            final file = File(result.path);
            final size = file.lengthSync();
            final bytes = await result.readAsBytes();
            final image = await decodeImageFromList(bytes);
            final name = result.name;
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

              _firestoreService.sendMessage(
                  message, widget.room.id, collectionID);
              _setAttachmentUploading(false);
            } on FirebaseException {
              _setAttachmentUploading(false);
              rethrow;
            }
          });
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
    _firestoreService.sendMessage(message, widget.room.id,
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
        titleSpacing: 0,
        title: Row(
          children: [
            CircularImage(
              image: widget.userProfileImage,
              radius: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 160,
              child: Marquee(
                child: Row(
                  children: [
                    AutoSizeText(
                      widget.userName,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Visibility(
                      visible: widget.isVerified,
                      child: const Icon(
                        Icons.verified,
                        color: Colors.blue,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          Tooltip(
            message: StringConstants.hintConnectionSecured,
            child: IconButton(
              onPressed: () {
                DialogsManager(context).showSecuredConnectionDialog();
              },
              icon: const Icon(
                Icons.lock_outlined,
                color: Colors.green,
              ),
            ),
          ),
          PopupMenuButton(
            onSelected: menuAction,
            itemBuilder: (BuildContext itemBuilder) =>
                StringConstants.menuDeleteDiscussion
                    .map(
                      (value) => PopupMenuItem(
                    child: Text(
                      value,
                      style: TextStyle(
                        color: Theme.of(context)
                            .inputDecorationTheme
                            .fillColor,
                      ),
                    ),
                    value: value,
                  ),
                )
                    .toList(),
          ),
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
              return Chat(
                  emojiEnlargementBehavior:
                  EmojiEnlargementBehavior.multi,
                  hideBackgroundOnEmojiMessages: true,
                  customBottomWidget: DiscussionsInput(
                    roomId: widget.room.id,
                    onSendPressed: _handleSendPressed,
                    onAttachmentPressed: _handleAttachmentPressed,
                    isAttachmentUploading: _isAttachmentUploading,
                  ),
                  showUserAvatars: true,
                  showUserNames: false,
                  usePreviewData: true,
                  theme: Theme.of(context).brightness == Brightness.dark
                      ? DarkChatUi(context: context)
                      : LightChatUi(context: context),
                  bubbleBuilder: _bubbleBuilder,
                  isAttachmentUploading: _isAttachmentUploading,
                  messages: snapshot.data ?? [],
                  onAttachmentPressed: _handleAttachmentPressed,
                  onMessageTap: _handleMessageTap,
                  onMessageLongPress: (value) async {
                    if (FirebaseAuth.instance.currentUser!.uid ==
                        value.author.id) {
                      DialogsManager(context)
                          .showUnsendMessageDialog(value);
                    }
                  },
                  onPreviewDataFetched: _handlePreviewDataFetched,
                  onSendPressed: _handleSendPressed,
                  user: types.User(
                    id: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
                  ));
            },
          );
        },
      ),
    );
  }

  void menuAction(String value) {
    switch (value) {
      case 'Delete Discussions':
        DialogsManager(context).showDeleteDiscussionDialog(widget.room);
        break;
    }
  }

  Widget _bubbleBuilder(
    Widget child, {
    required message,
    required nextMessageInGroup,
  }) {
    return Bubble(
      child: child,
      elevation: 0,
      padding: const BubbleEdges.all(0),
      radius: const Radius.circular(15),
      nipRadius: 3,
      color: _authService.currentUser()!.uid != message.author.id ||
              message.type == types.MessageType.image
          ? Theme.of(context).brightness == Brightness.light
              ? LightChatUi(context: context).secondaryColor
              : DarkChatUi(context: context).secondaryColor
          : Theme.of(context).brightness == Brightness.light
              ? LightChatUi(context: context).primaryColor
              : DarkChatUi(context: context).primaryColor,
      margin: nextMessageInGroup
          ? const BubbleEdges.symmetric(horizontal: 6)
          : null,
      nip: nextMessageInGroup
          ? BubbleNip.no
          : _authService.currentUser()!.uid != message.author.id
              ? BubbleNip.leftBottom
              : BubbleNip.rightBottom,
    );
  }
}
