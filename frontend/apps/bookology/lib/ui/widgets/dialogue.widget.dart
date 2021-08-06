import 'package:flutter/material.dart';

class Dialogue extends StatelessWidget {
  final String dialogueType;
  final String title;
  final String description;
  final Widget actions;

  const Dialogue({
    Key? key,
    required this.dialogueType,
    required this.title,
    required this.description,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Text(
                  this.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  this.description,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            this.actions,
          ],
        ),
      ),
    );
  }
}
