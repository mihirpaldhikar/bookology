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
          print('Case $value is not yet implemented');
      }
    }
  }
}
