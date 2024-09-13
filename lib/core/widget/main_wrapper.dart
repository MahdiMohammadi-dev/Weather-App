import 'package:flutter/material.dart';
import 'package:weatherclean/core/widget/app_background.dart';
import 'package:weatherclean/core/widget/bottom_nav.dart';
import 'package:weatherclean/features/bookamark_feature/presentation/screen/bookmark_screen.dart';
import 'package:weatherclean/features/weather_feature/presentation/screen/home_screen.dart';

class MainWrapper extends StatelessWidget {
  MainWrapper({super.key});

  final PageController pageController = PageController(initialPage: 0);


  @override
  Widget build(BuildContext context) {
    List<Widget> pageViewWidget = [
      const HomeScreen(),
       BookmarkScreen(pageController: pageController,),
    ];

    Size size = MediaQuery.sizeOf(context);
    return SafeArea(
        child: Scaffold(
          extendBody: true,
          bottomNavigationBar: BottomNav(controller: pageController,),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AppBackground.getBackGroundImage(),fit: BoxFit.cover),
            ),
            height:size.height,
            child: PageView(
              children: pageViewWidget,
              controller: pageController,

            ),
          ),
        ));
  }
}

