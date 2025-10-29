import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
   final String text;
   final VoidCallback onPressed;
   final Color color;
   final Color textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = Colors.indigo,
    this.textColor = Colors.white,
});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
      child: Text(text,style: TextStyle(fontSize: 18, color: textColor),),


    );
  }







}