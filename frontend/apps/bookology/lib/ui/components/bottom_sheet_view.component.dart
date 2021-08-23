import 'package:bookology/ui/widgets/drag_indicator.widget.dart';
import 'package:flutter/material.dart';

class BottomSheetView extends StatefulWidget {
  final List<Widget> contents;
  final String? title;
  final double height;

  const BottomSheetView({
    Key? key,
    required this.contents,
    required this.height,
    this.title = '',
  }) : super(key: key);

  @override
  _BottomSheetViewState createState() => _BottomSheetViewState();
}

class _BottomSheetViewState extends State<BottomSheetView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      padding: EdgeInsets.only(
        top: 10,
        right: 20,
        left: 20,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: dragIndicator(),
            ),
            Visibility(
              visible: widget.title!.isEmpty ? false : true,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(
                    top: 5,
                    bottom: 10,
                  ),
                  child: Text(
                    widget.title.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: widget.contents,
            )
          ],
        ),
      ),
    );
  }
}
