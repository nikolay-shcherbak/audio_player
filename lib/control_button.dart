import 'package:flutter/material.dart';
import 'package:music/custom_box.dart';

class Custombutton extends StatelessWidget {
  final Widget child;
  final onPressed;
  final double? size;
  final bool disabled;
  const Custombutton(
      {super.key,
      required this.child,
      required this.onPressed,
      this.size,
      this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return CustomBox(
      size: 0,
      child: ElevatedButton(
        style: ButtonStyle(
            shadowColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              return Colors.transparent;
            }),
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              return Colors.transparent;
            }),
            overlayColor: getColor(
                Colors.transparent, disabled ? Colors.red : Colors.amber),
            foregroundColor:
                getColor(disabled ? Colors.grey : Colors.black, Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            )),
        onPressed: onPressed,
        child: Center(child: child),
      ),
    );
  }

  MaterialStateProperty<Color> getColor(Color color, Color colorPressed) {
    getColor(Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    }

    return MaterialStateProperty.resolveWith(getColor);
  }
}
