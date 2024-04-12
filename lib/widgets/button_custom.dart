import 'package:flutter/material.dart';

class ButtonCustom extends StatelessWidget {
  ButtonCustom({
    super.key,
    this.backgroundColor = Colors.white,
    this.textStyle,
    this.textButton = 'CREATE AN ACCOUNT',
    required this.onTap,
    this.onloading = false,
  });
  Color backgroundColor;
  TextStyle? textStyle;
  String textButton;
  VoidCallback onTap;
  bool onloading;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        splashColor: Colors.white38,
        onTap: onTap,
        child: Ink(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).cardColor,
            ),
          ),
          child: Center(
            child: onloading
                ? const Center(child: CircularProgressIndicator())
                : Text(
                    textButton,
                    style: textStyle,
                  ),
          ),
        ),
      ),
    );
  }
}
