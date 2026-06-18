import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ValidationPasswordWidget extends StatelessWidget {
  const ValidationPasswordWidget({
    super.key,
    required this.text,
    required this.isValid,
  });

  final String text;
  final bool isValid;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        text,
        style: TextStyle(
          color: isValid ? Colors.green : Colors.red,
          fontSize: 13.sp,
        ),
      ),
      leading: Icon(
        isValid ? Icons.check_circle : Icons.cancel,
        color: isValid ? Colors.green : Colors.red,
        size: 14.sp,
      ),
    );
  }
}
