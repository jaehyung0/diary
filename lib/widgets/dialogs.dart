import 'package:flutter/material.dart';

enum DialogType { warning, info } // close... 다른이름 다른이름.

class ConfirmDialog extends SimpleDialog {
  ConfirmDialog(
    String title,
    Widget content,
    Function(bool) onClose, {
    Key? key,
    String? buttonLabel,
    String? cancelButtonLabel,
    bool showCancelButton = true,
    DialogType dialogType = DialogType.info,
    bool useButtons = true,
  }) : super(
          key: key,
          backgroundColor: Colors.transparent,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(title),
                    const SizedBox(height: 24),
                    content,
                    if (useButtons) const SizedBox(height: 24),
                    if (useButtons)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (showCancelButton)
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(200, 50),
                                ),
                                onPressed: () => onClose(false),
                                child: cancelButtonLabel != null
                                    ? Text(cancelButtonLabel)
                                    : const Text('취소'),
                              ),
                            ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(200, 50),
                              ),
                              onPressed: () => onClose(true),
                              child: cancelButtonLabel != null
                                  ? Text(cancelButtonLabel)
                                  : const Text('확인'),
                            ),
                          )
                        ],
                      )
                  ],
                ),
              ),
            )
          ],
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
        );
}

extension DialogExtensions on BuildContext {
  Future<bool> showConfirmDialog(
    String title,
    String content, {
    String? buttonLabel,
    String? cancelButtonLabel,
    DialogType dialogType = DialogType.info,
    bool showCancelButton = true,
  }) async {
    return await showDialog(
      context: this,
      builder: (context) => ConfirmDialog(
        title,
        Text(
          content,
          textAlign: TextAlign.center,
        ),
        (result) => Navigator.pop(context, result),
        buttonLabel: buttonLabel,
        dialogType: dialogType,
        cancelButtonLabel: cancelButtonLabel,
        showCancelButton: showCancelButton,
      ),
    );
  }

  Future<void> showMessageDialog(String title, Widget content,
      {String? buttonLabel, bool useButtons = true}) async {
    return await showDialog(
      context: this,
      builder: (context) => ConfirmDialog(
        title,
        content,
        (result) => Navigator.pop(context, result),
        useButtons: useButtons,
        showCancelButton: false,
        buttonLabel: buttonLabel,
      ),
    );
  }
}
