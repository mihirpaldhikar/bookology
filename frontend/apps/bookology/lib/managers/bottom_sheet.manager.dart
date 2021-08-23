import 'package:bookology/constants/colors.constant.dart';
import 'package:bookology/ui/components/bottom_sheet_view.component.dart';
import 'package:bookology/ui/widgets/outlined_button.widget.dart';
import 'package:flutter/material.dart';

class BottomSheetManager {
  final BuildContext context;

  BottomSheetManager(this.context);

  void showBookSelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => BottomSheetView(
        contents: [
          OutLinedButton(
            child: Row(
              children: [
                Icon(
                  Icons.share_outlined,
                  color: Theme.of(context).accentColor,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Share this book',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ],
            ),
            outlineColor: Theme.of(context).accentColor,
            backgroundColor: ColorsConstant.SECONDARY_COLOR,
            onPressed: () {},
          ),
          SizedBox(
            height: 20,
          ),
          OutLinedButton(
            child: Row(
              children: [
                Icon(
                  Icons.report_outlined,
                  color: Colors.redAccent,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Report this book',
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
            outlineColor: ColorsConstant.DANGER_BORDER_COLOR,
            backgroundColor: ColorsConstant.DANGER_BACKGROUND_COLOR,
            onPressed: () {},
          ),
        ],
        height: 200,
      ),
    );
  }
}
