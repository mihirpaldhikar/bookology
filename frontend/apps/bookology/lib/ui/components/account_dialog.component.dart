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

import 'package:bookology/constants/colors.constant.dart';
import 'package:bookology/constants/strings.constant.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/ui/widgets/circular_image.widget.dart';
import 'package:bookology/ui/widgets/drag_indicator.widget.dart';
import 'package:bookology/ui/widgets/outlined_button.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountDialog extends StatefulWidget {
  final String username;
  final String displayName;
  final String profileImageURL;
  final bool isVerified;

  const AccountDialog({
    Key? key,
    required this.username,
    required this.displayName,
    required this.profileImageURL,
    required this.isVerified,
  }) : super(key: key);

  @override
  _AccountDialogState createState() => _AccountDialogState();
}

class _AccountDialogState extends State<AccountDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: dragIndicator(),
            ),
            Text(
              StringConstants.APP_NAME,
              style: TextStyle(
                fontWeight: Theme.of(context).textTheme.headline4!.fontWeight,
                color: Theme.of(context).accentColor,
                fontSize: Theme.of(context).textTheme.headline5!.fontSize,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            CircularImage(
              image: widget.profileImageURL,
              radius: 90,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              widget.displayName,
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.username,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                SizedBox(
                  width: widget.isVerified ? 5 : 0,
                ),
                Visibility(
                  visible: widget.isVerified,
                  child: Icon(
                    Icons.verified,
                    color: Colors.blue,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 300,
              child: OutLinedButton(
                onPressed: () {
                  auth.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/auth',
                    (_) => false,
                  );
                },
                text: StringConstants.LOGOUT,
                showIcon: false,
                showText: true,
                outlineColor: ColorsConstant.DANGER_BORDER_COLOR,
                backgroundColor: ColorsConstant.DANGER_BACKGROUND_COLOR,
                textColor: Colors.redAccent,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 300,
              child: OutLinedButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                },
                text: StringConstants.CLOSE,
                showText: true,
                showIcon: false,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  StringConstants.SUPPORT,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
                Text(
                  StringConstants.CONTACT_US,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
