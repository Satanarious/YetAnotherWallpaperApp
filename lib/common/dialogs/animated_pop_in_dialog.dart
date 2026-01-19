import 'dart:ui';

import 'package:flutter/material.dart';

class AnimatedPopInDialog {
  static Future showGeneral(BuildContext context, Widget dialog) {
    return showGeneralDialog(
        barrierColor: Colors.black.withValues(alpha: 0.5),
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

  static Future showCustomized(
      {required BuildContext context,
      required String title,
      required IconData icon,
      required String description,
      required Map<String, Function> buttonNameAndFunctionMap}) {
    return showGeneralDialog(
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) => Container(),
      transitionBuilder: (context, a1, a2, wid) {
        return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: Dialog(
                backgroundColor: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.black.withAlpha(50),
                              border: Border.all(
                                color: Colors.white,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(30)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      icon,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ]),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                description,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: buttonNameAndFunctionMap.keys
                                      .map((buttonName) => Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: FilledButton(
                                              onPressed: () {
                                                buttonNameAndFunctionMap[
                                                    buttonName]!();
                                              },
                                              style: ButtonStyle(
                                                side: WidgetStateProperty
                                                    .resolveWith((states) =>
                                                        const BorderSide(
                                                            color:
                                                                Colors.white)),
                                                backgroundColor:
                                                    WidgetStateProperty
                                                        .resolveWith((states) =>
                                                            Theme.of(context)
                                                                .primaryColor
                                                                .withAlpha(
                                                                    120)),
                                              ),
                                              child: Text(buttonName),
                                            ),
                                          ))
                                      .toList()),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
