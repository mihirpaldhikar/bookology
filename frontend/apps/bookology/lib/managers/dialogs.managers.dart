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

import 'package:bookology/constants/values.constants.dart';
import 'package:bookology/managers/toast.manager.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/biomertics.service.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:bookology/services/firestore.service.dart';
import 'package:bookology/ui/components/animated_dialog.component.dart';
import 'package:bookology/ui/widgets/rounded_button.widget.dart';
import 'package:bookology/utils/validator.util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:local_auth/local_auth.dart';

class DialogsManager {
  final BuildContext context;

  final FirestoreService firestoreService =
      FirestoreService(FirebaseFirestore.instance);

  DialogsManager(this.context);

  void showDeleteDiscussionDialog(types.Room room) {
    showDialog(
      context: context,
      builder: (context) => AnimatedDialog(
        title: 'Delete Discussion?',
        content: [
          Text(
            'This will delete the discussion for both'
            ' the users. This action is '
            'irreversible & you will need to request '
            'the uploader to start discussion '
            'again.',
            style: TextStyle(
              color: Theme.of(context).inputDecorationTheme.fillColor,
            ),
          ),
        ],
        actions: [
          RoundedButton(
            text: 'Delete',
            outlineWidth: ValuesConstant.outlineWidth,
            textColor: Theme.of(context).colorScheme.primary,
            onPressed: () async {
              Navigator.of(context).pop();
              await firestoreService.deleteDiscussionRoom(
                  discussionRoomID: room.id);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          RoundedButton(
            text: 'Cancel',
            outlineWidth: ValuesConstant.outlineWidth,
            textColor: Theme.of(context).colorScheme.primary,
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
        ],
        dialogIcon: const Icon(
          Icons.delete_forever_outlined,
          color: Colors.red,
        ),
      ),
    );
  }

  void showUnsendMessageDialog(types.Message message) {
    showDialog(
      context: context,
      builder: (context) => AnimatedDialog(
        title: 'Unsend Message?',
        content: [
          Text(
            'You will be able to unsend the message '
            'you have sent.',
            style: TextStyle(
              color: Theme.of(context).inputDecorationTheme.fillColor,
            ),
          ),
        ],
        actions: [
          RoundedButton(
            text: 'Unsend',
            outlineWidth: ValuesConstant.outlineWidth,
            textColor: Theme.of(context).colorScheme.error,
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
          RoundedButton(
            text: 'Cancel',
            outlineWidth: ValuesConstant.outlineWidth,
            textColor: Theme.of(context).colorScheme.primary,
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
        ],
        dialogIcon: const Icon(
          Icons.auto_delete_outlined,
          color: Colors.red,
        ),
      ),
    );
  }

  void showSecuredConnectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AnimatedDialog(
        title: 'Secured Connection',
        content: const [
          Text(
            'This discussion is end-to-end secured. '
            'No one even Bookology can read the ongoing '
            'discussions.',
          ),
        ],
        actions: [
          RoundedButton(
            text: 'OK',
            outlineWidth: ValuesConstant.outlineWidth,
            textColor: Theme.of(context).colorScheme.primary,
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
        ],
        dialogIcon: const Icon(
          Icons.lock_outlined,
          color: Colors.green,
        ),
      ),
    );
  }

  void showAboutSponsoredDialog() {
    showDialog(
      context: context,
      builder: (context) => AnimatedDialog(
        title: 'Advertisement',
        content: [
          Text(
            'Sponsored or advertisement are the essential part '
            'inorder to maintain the underlying infrastructure. '
            'This ADs are sourced from Google ADs Network. We '
            'don\'t collect the information to show you ADs.',
            style: TextStyle(
              color: Theme.of(context).inputDecorationTheme.fillColor,
            ),
          ),
        ],
        actions: [
          RoundedButton(
            text: 'OK',
            outlineWidth: ValuesConstant.outlineWidth,
            textColor: Theme.of(context).colorScheme.primary,
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
        ],
        dialogIcon: const Icon(
          Icons.campaign_outlined,
        ),
      ),
    );
  }

  void showWhatIsIsbnDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AnimatedDialog(
        title: 'About ISBN',
        content: [
          Text(
            'The International Standard Book Number (ISBN) is a numeric commercial book identifier which is intended to be unique.'
            '\nAn ISBN is assigned to each separate '
            'edition and variation (except '
            'reprintings) of a publication.',
            style: TextStyle(
              color: Theme.of(context).inputDecorationTheme.fillColor,
            ),
          ),
        ],
        actions: [
          RoundedButton(
            text: 'OK',
            outlineWidth: ValuesConstant.outlineWidth,
            textColor: Theme.of(context).colorScheme.primary,
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
        ],
        dialogIcon: const Icon(
          Icons.info_outlined,
        ),
      ),
    );
  }

  void showLocationPermissionDialog(VoidCallback onPressed) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AnimatedDialog(
        title: 'Location Permission',
        content: [
          Text(
            'Inorder to show the books listed nearby you, we require the location permission. '
            'We required only approximate location which includes current district, state & '
            'country. You can disable the location permission if you want but you will not get '
            'relevant book recommendations.',
            style: TextStyle(
              color: Theme.of(context).inputDecorationTheme.fillColor,
            ),
          ),
        ],
        actions: [
          RoundedButton(
            text: 'Next',
            outlineWidth: ValuesConstant.outlineWidth,
            textColor: Theme.of(context).colorScheme.primary,
            onPressed: onPressed,
          )
        ],
        dialogIcon: const Icon(
          Icons.place_outlined,
        ),
      ),
    );
  }

  void showDeleteBookDialog(VoidCallback onDelete) {
    showDialog(
      context: context,
      builder: (context) => AnimatedDialog(
        title: 'Delete Book?',
        content: [
          Text(
            'This book will be deleted. This action '
            'is not irreversible.',
            style: TextStyle(
              color: Theme.of(context).inputDecorationTheme.fillColor,
            ),
          ),
        ],
        actions: [
          RoundedButton(
            text: 'Delete',
            outlineWidth: ValuesConstant.outlineWidth,
            textColor: Theme.of(context).colorScheme.error,
            onPressed: onDelete,
          ),
          const SizedBox(
            height: 15,
          ),
          RoundedButton(
            text: 'Cancel',
            outlineWidth: ValuesConstant.outlineWidth,
            textColor: Theme.of(context).colorScheme.primary,
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
        ],
        dialogIcon: const Icon(
          Icons.delete_forever_outlined,
          color: Colors.red,
        ),
      ),
    );
  }

  void showProgressDialog(
      {required String content, Color? contentColor, Color? progressColor}) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              progressColor ?? Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 7,
            ),
            child: Text(
              content,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: contentColor ??
                    Theme.of(context).colorScheme.onBackground,
              ),
            ),
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

  void acceptDiscussionRequestDialog({
    required VoidCallback onRequestAccepted,
    required String requestText,
  }) {
    showDialog(
      context: context,
      builder: (context) => AnimatedDialog(
        title: 'Accept Request?',
        content: [
          Text(
            '$requestText.\nThis will create a Discussions Between you and the requesting user.',
            style: TextStyle(
              color: Theme.of(context).inputDecorationTheme.fillColor,
            ),
          ),
        ],
        actions: [
          RoundedButton(
            text: 'Accept',
            outlineWidth: ValuesConstant.outlineWidth,
            textColor: Theme.of(context).colorScheme.primary,
            onPressed: onRequestAccepted,
          ),
          const SizedBox(
            height: 15,
          ),
          RoundedButton(
            text: 'Reject',
            outlineWidth: ValuesConstant.outlineWidth,
            textColor: Theme.of(context).colorScheme.primary,
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
        ],
        dialogIcon: const Icon(
          Icons.check_circle_outlined,
          color: Colors.green,
        ),
      ),
    );
  }

  void sendDiscussionRequestDialog({
    required VoidCallback onRequestSend,
  }) {
    showDialog(
      context: context,
      builder: (context) => AnimatedDialog(
        title: 'Send Request?',
        content: [
          Text(
            'This will create a request to the uploader. You will only be able to discuss if the uploader accepts your request.',
            style: TextStyle(
              color: Theme.of(context).inputDecorationTheme.fillColor,
            ),
          ),
        ],
        actions: [
          RoundedButton(
            text: 'Request',
            outlineWidth: ValuesConstant.outlineWidth,
            textColor: Theme.of(context).colorScheme.primary,
            onPressed: onRequestSend,
          ),
          const SizedBox(
            height: 15,
          ),
          RoundedButton(
            text: 'Cancel',
            outlineWidth: ValuesConstant.outlineWidth,
            textColor: Theme.of(context).colorScheme.primary,
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
        ],
        dialogIcon: const Icon(
          Icons.question_answer_outlined,
        ),
      ),
    );
  }

  void showResetPasswordDialog() {
    final _formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AnimatedDialog(
        title: 'Reset Password',
        content: [
          Form(
            key: _formKey,
            child: Column(children: [
              Text(
                'Please enter the Email from which you have created the Bookology Account.',
                style: TextStyle(
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                style: TextStyle(
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                ),
                decoration: InputDecoration(
                    labelText: "Email",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(),
                    ),
                    prefixIcon: const Icon(Icons.mail_outline_rounded)
                    //fillColor: Colors.green
                    ),
                controller: emailController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Email cannot be empty.";
                  } else {
                    if (!Validator().validateEmail(val)) {
                      return "Email is not valid.";
                    } else {
                      return null;
                    }
                  }
                },
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                textInputAction: TextInputAction.done,
              ),
            ]),
          ),
        ],
        actions: [
          RoundedButton(
            text: 'Send Reset Link',
            outlineWidth: ValuesConstant.outlineWidth,
            textColor: Theme.of(context).colorScheme.primary,
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final result = await AuthService(FirebaseAuth.instance)
                    .sendResetPasswordEmail(
                  email: emailController.text,
                );
                if (result) {
                  Navigator.of(context).pop();
                  ToastManager(context).showToast(
                    message: 'Check the Email for the reset link.',
                  );
                }
              }
            },
          ),
          const SizedBox(
            height: 15,
          ),
          RoundedButton(
            text: 'Cancel',
            textColor: Theme.of(context).colorScheme.primary,
            outlineWidth: ValuesConstant.outlineWidth,
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
        ],
        dialogIcon: const Icon(
          Icons.restart_alt_outlined,
        ),
      ),
    );
  }

  void showSendAttachmentDialog({
    required String attachmentName,
    required String receiverName,
    required VoidCallback onSendClicked,
  }) {
    showDialog(
      context: context,
      builder: (context) => AnimatedDialog(
        title: 'Send Attachment?',
        actions: [
          RoundedButton(
            text: 'Send',
            textColor: Theme.of(context).colorScheme.primary,
            outlineWidth: ValuesConstant.outlineWidth,
            onPressed: onSendClicked,
          ),
          const SizedBox(
            height: 15,
          ),
          RoundedButton(
            text: 'Cancel',
            textColor: Theme.of(context).colorScheme.primary,
            outlineWidth: 2,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        content: [
          Text(
            'Send "$attachmentName" to $receiverName?',
            style: TextStyle(
              color: Theme.of(context).inputDecorationTheme.fillColor,
            ),
          ),
        ],
        dialogIcon: const Icon(
          Icons.ios_share_outlined,
        ),
      ),
    );
  }

  void showLogoutDialog({
    required VoidCallback onLogoutClicked,
  }) {
    showDialog(
      context: context,
      builder: (context) => AnimatedDialog(
        title: 'Logout',
        actions: [
          RoundedButton(
            text: 'Confirm',
            textColor: Theme.of(context).colorScheme.primary,
            outlineWidth: ValuesConstant.outlineWidth,
            onPressed: onLogoutClicked,
          ),
          const SizedBox(
            height: 15,
          ),
          RoundedButton(
            text: 'Cancel',
            textColor: Theme.of(context).colorScheme.primary,
            outlineWidth: ValuesConstant.outlineWidth,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        content: [
          Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              color: Theme.of(context).inputDecorationTheme.fillColor,
            ),
          ),
        ],
        dialogIcon: const Icon(
          Icons.logout_outlined,
        ),
      ),
    );
  }

  void showLocationNotGrantedDialog({
    required VoidCallback onOpenSettingsClicked,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AnimatedDialog(
        title: 'Location Permission',
        actions: [
          RoundedButton(
            text: 'Allow',
            textColor: Theme.of(context).colorScheme.primary,
            outlineWidth: ValuesConstant.outlineWidth,
            onPressed: onOpenSettingsClicked,
          ),
        ],
        content: [
          Text(
            'The location permission is either not granted or currently not available. Please Allow the location permission in order to continue.',
            style: TextStyle(
              color: Theme.of(context).inputDecorationTheme.fillColor,
            ),
          ),
        ],
        dialogIcon: const Icon(
          Icons.place_outlined,
        ),
      ),
    );
  }

  void showBiometricsSelectionDialog() async {
    bool _isBiometricsEnabled = PreferencesManager().isBiometricsEnabled();
    final List<BiometricType> availableBiometrics =
        await BiometricsService(context).getAvailableBiometrics();
    showDialog(
      context: context,
      builder: (BuildContext context) => AnimatedDialog(
          title: 'Use Biometrics',
          content: [
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  children: [
                    Text(
                      'Authenticate with the Biometrics which are available and supported by your device.',
                      style: TextStyle(
                        color: Theme.of(context).inputDecorationTheme.fillColor,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Available Biometrics',
                        style: TextStyle(
                          color:
                              Theme.of(context).inputDecorationTheme.fillColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: availableBiometrics.isNotEmpty,
                      child: SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            itemCount: availableBiometrics.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 5,
                                ),
                                child: Text(
                                  availableBiometrics[index] ==
                                          BiometricType.fingerprint
                                      ? 'Fingerprint Biometric'
                                      : availableBiometrics[index] ==
                                              BiometricType.face
                                          ? 'Face Biometric'
                                          : 'Unknown Biometric',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .inputDecorationTheme
                                        .fillColor,
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Use Biometrics',
                          style: TextStyle(
                            color: Theme.of(context)
                                .inputDecorationTheme
                                .fillColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Switch(
                          value: _isBiometricsEnabled,
                          onChanged: (val) {
                            setState(() {
                              _isBiometricsEnabled = val;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                );
              },
            )
          ],
          actions: [
            RoundedButton(
              text: 'Done',
              textColor: Theme.of(context).colorScheme.primary,
              outlineWidth: ValuesConstant.outlineWidth,
              onPressed: () async {
                if (_isBiometricsEnabled) {
                  if (await BiometricsService(this.context)
                          .isBiometricsAvailable() &&
                      await BiometricsService(this.context)
                          .canCheckBiometrics()) {
                    await BiometricsService(this.context)
                        .authenticateWithBiometrics(
                            bioAuthReason:
                                'Verify your Biometric in order to enable the security feature.',
                            useOnlyBiometrics: true,
                            onBioAuthStarted: () {
                              Navigator.pop(this.context);
                            },
                            onBioAuthCompleted: (isVerified) {
                              if (isVerified) {
                                PreferencesManager().setIsBiometricEnabled(
                                    isEnabled: isVerified);
                                ToastManager(this.context).showToast(
                                    message:
                                        'Biometric verified successfully.');
                              } else {
                                ToastManager(this.context).showToast(
                                    message: 'Biometrics verification failed.');
                              }
                            },
                            onBioAuthError: (PlatformException error) {
                              ToastManager(this.context).showToast(
                                  message: 'Biometrics verification failed.');
                            });
                  }
                } else {
                  PreferencesManager().setIsBiometricEnabled(isEnabled: false);
                  Navigator.of(this.context).pop();
                }
              },
            ),
            const SizedBox(
              height: 15,
            ),
            RoundedButton(
              text: 'Cancel',
              outlineWidth: ValuesConstant.outlineWidth,
              textColor: Theme.of(context).colorScheme.primary,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          dialogIcon: const Icon(
            Icons.fingerprint_outlined,
          )),
    );
  }
}
