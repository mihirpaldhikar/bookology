import 'package:bookology/services/auth.service.dart';
import 'package:bookology/ui/widgets/circular_image.widget..dart';
import 'package:bookology/ui/widgets/outlined_button.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountDialog extends StatefulWidget {
  const AccountDialog({Key? key}) : super(key: key);

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

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeInCubic);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return ScaleTransition(
      scale: scaleAnimation,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Container(
          width: 700,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Bookology',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                CircularImage(
                  image: auth.currentUser()!.photoURL.toString(),
                  radius: 40,
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      auth.currentUser()!.displayName.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.verified,
                      color: Colors.blue,
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  auth.currentUser()!.email.toString(),
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                OutLinedButton(
                  onPressed: () {
                    auth.signOut();
                    Navigator.pushReplacementNamed(context, '/auth');
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
                ),
                SizedBox(
                  height: 10,
                ),
                OutLinedButton(
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
        ),
      ),
    );
  }
}
