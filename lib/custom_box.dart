import 'package:flutter/material.dart';

class CustomBox extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final child;
  final double? size;
  const CustomBox({Key? key, required this.child, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(size ?? 8),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          // darker shadow on the bottom right
          BoxShadow(
            color: Colors.grey.shade500,
            blurRadius: 15,
            offset: const Offset(5, 5),
          ),

          // lighter shadow on the top left
          const BoxShadow(
            color: Colors.white,
            blurRadius: 15,
            offset: Offset(-5, -5),
          ),
        ],
      ),
      child: Center(child: child),
    );
  }
}
