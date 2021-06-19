import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthHandler {
  dynamic firebaseError(
      {required dynamic value, required BuildContext context}) {
    if (Platform.isAndroid) {
      switch (value) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No user associated with the email id.'),
            ),
          );
          break;
        case 'The password is invalid or the user does not have a password.':
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid password.'),
            ),
          );
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error in connecting to server. '
                  'Please check your Network.'),
            ),
          );
          break;
        case 'The email address is already in use by another account.':
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('The email is already in use. Please Login instead'
                  '.'),
            ),
          );
          break;
        case 'The user account has been disabled by an administrator.':
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => AlertDialog(
              title: Text('Suspended'),
              content: Text(
                'Your account has '
                'been banned from accessing the'
                ' Bookology. \n\nIf it was a mistake, please contact support.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: Text('Exit'),
                ),
              ],
            ),
          );
          break;
        default:
          print('Case ${value} is not yet implemented');
      }
    }
  }
}
