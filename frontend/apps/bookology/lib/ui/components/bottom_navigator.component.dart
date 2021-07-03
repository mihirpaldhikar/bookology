import 'package:bookology/ui/widgets/bottom_app_bar_item.widget.dart';
import 'package:flutter/material.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({Key? key}) : super(key: key);

  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        height: 60,
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            BottomAppBarItem(
              icon: Icons.home,
              isActive: true,
              tooltip: 'Home',
              onPressed: () {},
            ),
            BottomAppBarItem(
              icon: Icons.notifications,
              isActive: false,
              tooltip: 'Notifications',
              onPressed: () {},
            ),
            SizedBox(
              width: 40,
            ),
            BottomAppBarItem(
              icon: Icons.question_answer,
              isActive: false,
              tooltip: 'Chats',
              onPressed: () {},
            ),
            BottomAppBarItem(
              icon: Icons.account_circle_outlined,
              isActive: false,
              tooltip: 'Manage Account',
              onPressed: () {},
            ),
          ],
        ),
      ),
      shape: AutomaticNotchedShape(
        RoundedRectangleBorder(),
        StadiumBorder(
          side: BorderSide(),
        ),
      ),
    );
  }
}
