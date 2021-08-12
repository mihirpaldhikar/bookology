import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/src/widgets/inherited_l10n.dart';

/// A class that represents send button widget
class SendChatButton extends StatelessWidget {
  /// Creates send button widget
  const SendChatButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  /// Callback for send button tap event
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 77,
      padding: const EdgeInsets.all(2),
      child: Padding(
        padding: EdgeInsets.zero,
        child: Tooltip(
          message: InheritedL10n.of(context).l10n.sendButtonAccessibilityLabel,
          child: TextButton(
            child: Text(
              'Send',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
