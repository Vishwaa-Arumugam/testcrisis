import 'package:flutter/material.dart';

class Tags extends StatelessWidget {
  final String text;
  final String imagePath;
  final VoidCallback? onTap;
  final double size;
  final double h;
  final double w;
  const Tags({
    Key? key,
    required this.text,
    required this.imagePath,
    required this.onTap,
    this.size = 14,
    this.h = 40,
    this.w = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 2.0,
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.black,
                      fontSize: size,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 2),
              Image.asset(
                imagePath,
                width: w, // Adjust image size as needed
                height: h,
                fit: BoxFit.contain, // Adjust image fit
              ),
              // Adjust spacing between image and text
            ],
          ),
        ),
      ),
    );
  }
}
