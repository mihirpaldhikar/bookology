import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/src/widgets/inherited_chat_theme.dart';
import 'package:flutter_chat_ui/src/widgets/inherited_l10n.dart';

/// A class that represents attachment button widget
class FileAttachmentButton extends StatelessWidget {
  /// Creates attachment button widget
  const FileAttachmentButton({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  /// Callback for attachment button tap event
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 50,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(
        top: 5,
        bottom: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: IconButton(
          icon: InheritedChatTheme.of(context).theme.attachmentButtonIcon !=
                  null
              ? InheritedChatTheme.of(context).theme.attachmentButtonIcon!
              : Image.asset(
                  'assets/icon-attachment.png',
                  color: InheritedChatTheme.of(context).theme.inputTextColor,
                  package: 'flutter_chat_ui',
                ),
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          tooltip:
              InheritedL10n.of(context).l10n.attachmentButtonAccessibilityLabel,
        ),
      ),
    );
  }
}
