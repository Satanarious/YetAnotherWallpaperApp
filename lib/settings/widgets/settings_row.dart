import 'package:flutter/material.dart';

class SettingsRow extends StatelessWidget {
  const SettingsRow({
    required this.settingIcon,
    required this.settingName,
    required this.settingWidget,
    this.isDisabled = false,
    super.key,
  });
  final IconData settingIcon;
  final String settingName;
  final Widget settingWidget;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        Icon(settingIcon, color: isDisabled ? Colors.grey : Colors.white),
        const SizedBox(
          width: 5,
        ),
        Text(
          settingName,
          style: TextStyle(
              color: isDisabled ? Colors.grey : Colors.white, fontSize: 16),
        ),
        const Expanded(
          child: SizedBox(
            height: 10,
            child: null,
          ),
        ),
        settingWidget
      ],
    );
  }
}
