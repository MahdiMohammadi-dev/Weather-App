import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  PageController controller;

  BottomNav({super.key, required this.controller});


  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme
        .of(context)
        .primaryColor;
    TextTheme textTheme = Theme
        .of(context)
        .textTheme;

    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 5,
      color: primaryColor,
      child: SizedBox(
        height: 63,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(onPressed: () {
              controller.animateToPage(
                  0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
            }, icon: Icon(Icons.home)),
            SizedBox(),

            IconButton(onPressed: () {
              controller.animateToPage(
                  1, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
            }, icon: Icon(Icons.bookmark)),
          ],
        ),
      ),
    );
  }
}
