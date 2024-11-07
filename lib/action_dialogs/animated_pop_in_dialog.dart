import 'package:flutter/material.dart';

class AnimatedPopInDialog {
  static Future show(BuildContext context, Widget dialog) {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, wid) {
          return Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: dialog,
              ));
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) => Container());
  }
}
