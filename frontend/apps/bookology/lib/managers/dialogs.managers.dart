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

import 'package:bookology/services/firestore.service.dart';
import 'package:bookology/ui/widgets/outlined_button.widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class DialogsManager {
  final BuildContext context;

  final FirestoreService firestoreService =
      FirestoreService(FirebaseFirestore.instance);

  DialogsManager(this.context);

  void showDeleteDiscussionDialog(types.Room room) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Row(
                children: const [
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
              content: SizedBox(
                height: 280,
                child: Column(
                  children: [
                    const Text(
                      'This will delete the discussion for both'
                      ' the users. This action is '
                      'irreversible & you will need to request '
                      'the uploader to start discussion '
                      'again.',
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    OutLinedButton(
                      text: 'Delete',
                      showIcon: false,
                      showText: true,
                      outlineColor: Colors.redAccent,
                      backgroundColor: Colors.red[100],
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await firestoreService.deleteDiscussionRoom(
                            discussionRoomID: room.id);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    OutLinedButton(
                      text: 'Cancel',
                      showIcon: false,
                      showText: true,
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ));
  }

  void showUnsendMessageDialog(types.Message message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
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
        content: SizedBox(
          height: 200,
          child: Column(
            children: [
              const Text(
                'You will be able to unsend the message '
                'you have sent.',
              ),
              const SizedBox(
                height: 30,
              ),
              OutLinedButton(
                text: 'Unsend',
                showIcon: false,
                showText: true,
                outlineColor: Colors.redAccent,
                backgroundColor: Colors.red[100],
                onPressed: () async {
                  Navigator.of(context).pop();
                  await firestoreService.unsendMessage(
                    messageID: message.id,
                    mediaURL: message.toJson()['uri'] ?? '',
                    roomID: message.roomId as String,
                    messageType: message.type.toString(),
                  );
                },
              ),
              const SizedBox(
                height: 15,
              ),
              OutLinedButton(
                text: 'Cancel',
                showIcon: false,
                showText: true,
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

  void showSecuredConnectionDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Row(
                children: const [
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
              content: SizedBox(
                height: 180,
                child: Column(
                  children: [
                    const Text(
                      'This discussion is end-to-end secured. '
                      'No one even Bookology can read the ongoing '
                      'discussions.',
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    OutLinedButton(
                      text: 'OK',
                      showIcon: false,
                      showText: true,
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
  }

  void showAboutSponsoredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.campaign_outlined,
              color: Theme.of(context).colorScheme.secondary,
              size: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Sponsored Content',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SizedBox(
          height: 260,
          child: Column(
            children: [
              const Text(
                'Sponsored or advertisement are the essential part '
                'inorder to maintain the underlying infrastructure. '
                'This ADs are sourced from Google ADs Network. We '
                'don\'t collect the information to show you ADs.',
              ),
              const SizedBox(
                height: 30,
              ),
              OutLinedButton(
                text: 'OK',
                showIcon: false,
                showText: true,
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

  void showWhatIsIsbnDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'About ISBN',
        ),
        content: SizedBox(
          height: 300,
          child: Column(
            children: [
              const Text(
                'The International Standard Book Number (ISBN) is a numeric commercial book identifier which is intended to be unique.'
                '\nAn ISBN is assigned to each separate '
                'edition and variation (except '
                'reprintings) of a publication.',
              ),
              const SizedBox(
                height: 30,
              ),
              OutLinedButton(
                text: 'OK',
                showIcon: false,
                showText: true,
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

  void showLocationPermissionDialog(VoidCallback onPressed) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.place_outlined,
              color: Theme.of(context).colorScheme.secondary,
              size: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Location Permission',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SizedBox(
          height: 300,
          child: Column(
            children: [
              const Text(
                'Inorder to show the books listed nearby you, we require the location permission. '
                'We required only approximate location which includes current district, state & '
                'country. You can disable the location permission if you want but you will not get '
                'relevant book recommendations.',
              ),
              const SizedBox(
                height: 30,
              ),
              OutLinedButton(
                text: 'Next',
                showIcon: false,
                showText: true,
                onPressed: onPressed,
              )
            ],
          ),
        ),
      ),
    );
  }

  void showDeleteBookDialog(VoidCallback onDelete) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Row(
                children: const [
                  Icon(
                    Icons.delete_forever_outlined,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Delete Book?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                height: 200,
                child: Column(
                  children: [
                    const Text(
                      'This book will be deleted. This action '
                      'is not irreversible.',
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    OutLinedButton(
                      text: 'Delete',
                      showIcon: false,
                      showText: true,
                      outlineColor: Colors.redAccent,
                      backgroundColor: Colors.red[100],
                      onPressed: onDelete,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    OutLinedButton(
                      text: 'Cancel',
                      showIcon: false,
                      showText: true,
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ));
  }

  void showInstallAppDialog(VoidCallback onRequest) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Row(
                children: const [
                  Icon(
                    Icons.delete_forever_outlined,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Permission Required',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                height: 200,
                child: Column(
                  children: [
                    const Text(
                      'This book will be deleted. This action '
                      'is not irreversible.',
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    OutLinedButton(
                      text: 'Delete',
                      showIcon: false,
                      showText: true,
                      outlineColor: Colors.redAccent,
                      backgroundColor: Colors.red[100],
                      onPressed: onRequest,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    OutLinedButton(
                      text: 'Cancel',
                      showIcon: false,
                      showText: true,
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ));
  }

  void showProgressDialog(
      {required String content,
      required Color contentColor,
      required Color progressColor}) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              progressColor,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 7,
            ),
            child: Text(content),
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
