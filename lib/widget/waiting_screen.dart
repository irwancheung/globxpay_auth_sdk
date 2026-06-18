import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
class WaitingScreen extends StatelessWidget {
  const WaitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
   
    
    final baseColor =
         AppColors.primary;
    final backgroundColor = baseColor.withOpacity(0.2); // 20% opacity

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: backgroundColor, // translucent background
      alignment: Alignment.center,
      child: CircularProgressIndicator.adaptive(
        backgroundColor: Colors.transparent,
        valueColor: AlwaysStoppedAnimation<Color>(baseColor), // solid spinner
      ),
    );
  }
}
