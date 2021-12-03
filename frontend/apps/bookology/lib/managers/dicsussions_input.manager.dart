/*
 * Copyright 2021 Mihir Paldhikar
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation the
 *  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is furnished
 *  to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies
 *  or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

import 'package:bookology/managers/chat_ui.manager.dart';
import 'package:bookology/services/firestore.service.dart';
import 'package:bookology/ui/components/file_attachment_button.component.dart';
import 'package:bookology/ui/components/send_chat_button.component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class NewLineIntent extends Intent {
  const NewLineIntent();
}

class SendMessageIntent extends Intent {
  const SendMessageIntent();
}

/// A class that represents bottom bar widget with a text field, attachment and
/// send buttons inside. Hides send button when text field is empty.
class DiscussionsInput extends StatefulWidget {
  /// Creates [DiscussionsInput] widget
  const DiscussionsInput({
    Key? key,
    this.isAttachmentUploading,
    this.onAttachmentPressed,
    required this.onSendPressed,
    this.onTextChanged,
    required this.roomId,
  }) : super(key: key);

  /// See [AttachmentButton.onPressed]
  final void Function()? onAttachmentPressed;

  /// Whether attachment is uploading. Will replace attachment button with a
  /// [CircularProgressIndicator]. Since we don't have libraries for
  /// managing media in dependencies we have no way of knowing if
  /// something is uploading so you need to set this manually.
  final bool? isAttachmentUploading;

  /// Will be called on [SendButton] tap. Has [types.PartialText] which can
  /// be transformed to [types.TextMessage] and added to the messages list.
  final void Function(types.PartialText) onSendPressed;

  /// Will be called whenever the text inside [TextField] changes
  final void Function(String)? onTextChanged;
  final String roomId;

  @override
  _DiscussionsInputState createState() => _DiscussionsInputState();
}

/// [DiscussionsInput] widget state
class _DiscussionsInputState extends State<DiscussionsInput> {
  final _inputFocusNode = FocusNode();
  bool _sendButtonVisible = false;
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.addListener(_handleTextControllerChange);
  }

  @override
  void dispose() {
    _inputFocusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _handleSendPressed() {
    final _partialText = types.PartialText(text: _textController.text.trim());
    widget.onSendPressed(_partialText);
    _textController.clear();
    FirestoreService(FirebaseFirestore.instance)
        .updateTheRoomUpdatedAt(
          roomId: widget.roomId,
        )
        .then((value) => null);
  }

  void _handleTextControllerChange() {
    setState(() {
      _sendButtonVisible = _textController.text.trim() != '';
    });
  }

  Widget _leftWidget() {
    if (widget.isAttachmentUploading == true) {
      return Container(
        height: 24,
        margin: const EdgeInsets.only(right: 16),
        width: 24,
        child: CircularProgressIndicator(
          backgroundColor: Colors.transparent,
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
              ChatUiTheme(context: context).inputTextColor),
        ),
      );
    } else {
      return FileAttachmentButton(onPressed: widget.onAttachmentPressed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _inputFocusNode.requestFocus(),
      child: Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.enter): const SendMessageIntent(),
          LogicalKeySet(LogicalKeyboardKey.enter, LogicalKeyboardKey.alt):
              const NewLineIntent(),
          LogicalKeySet(LogicalKeyboardKey.enter, LogicalKeyboardKey.shift):
              const NewLineIntent(),
        },
        child: Actions(
          actions: {
            SendMessageIntent: CallbackAction<SendMessageIntent>(
              onInvoke: (SendMessageIntent intent) => _handleSendPressed(),
            ),
            NewLineIntent: CallbackAction<NewLineIntent>(
              onInvoke: (NewLineIntent intent) {
                final _newValue = '${_textController.text}\r\n';
                _textController.value = TextEditingValue(
                  text: _newValue,
                  selection: TextSelection.fromPosition(
                    TextPosition(offset: _newValue.length),
                  ),
                );
              },
            ),
          },
          child: Focus(
            autofocus: true,
            child: Container(
              height: 52,
              margin: const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 10,
              ),
              padding: const EdgeInsets.only(
                left: 10,
                right: 0,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 0.5,
                ),
                borderRadius: ChatUiTheme(context: context).inputBorderRadius,
                color: ChatUiTheme(context: context).inputBackgroundColor,
              ),
              child: Material(
                borderRadius: ChatUiTheme(context: context).inputBorderRadius,
                color: ChatUiTheme(context: context).inputBackgroundColor,
                child: Row(
                  children: [
                    if (widget.onAttachmentPressed != null) _leftWidget(),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration.collapsed(
                          hintStyle: ChatUiTheme(context: context)
                              .inputTextStyle
                              .copyWith(
                                color: ChatUiTheme(context: context)
                                    .inputTextColor
                                    .withOpacity(0.5),
                              ),
                          hintText: 'Message...',
                        ),
                        focusNode: _inputFocusNode,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        minLines: 1,
                        onChanged: widget.onTextChanged,
                        style: TextStyle(
                          color:
                              Theme.of(context).inputDecorationTheme.fillColor,
                        ),
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                    Visibility(
                      visible: _sendButtonVisible,
                      child: SendChatButton(
                        onPressed: _handleSendPressed,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
