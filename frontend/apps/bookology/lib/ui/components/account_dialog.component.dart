import 'package:bookology/services/auth.service.dart';
import 'package:bookology/ui/widgets/circular_image.widget.dart';
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
            SizedBox(
              height: 20,
            ),
            Text(
              'Bookology',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            CircularImage(
              image: widget.profileImageURL,
              radius: 90,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              widget.displayName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                outlineColor: Colors.redAccent,
                backgroundColor: Colors.red[50],
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Close'),
                  ],
                ),
                outlineColor: Colors.grey,
                backgroundColor: Colors.grey[50],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Support',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'Contact Us',
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
