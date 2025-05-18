import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help_on_maps/modules/splash/widgets/onboarding_page.dart';
import 'package:help_on_maps/routes/app_pages.dart';
import 'package:onboarding/onboarding.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xAAcfe0f3), Colors.white],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Onboarding(
            swipeableBody: [
              OnboardingPage(
                title: 'Welcome to HelpMap',
                description:
                    'Connect with people nearby who need help or want to offer help.',
                image: Image.asset('assets/images/HelpMap.png'),
              ),
              OnboardingPage(
                title: 'A New Way To Help',
                description:
                    'HelpMap is the fastest way to make a difference in your community. Whether it\'s getting things done or lending a hand, we\'re in this together.',
                image: Icon(Icons.chat, size: 120, color: Colors.green),
              ),
              OnboardingPage(
                title: 'HelpMap is a free app that connects disaster victims with volunteers',
                description:
                    'We work to keep family safe, warm, and fed during disasters.',
                image: Icon(Icons.navigation, size: 120, color: Colors.orange),
              ),
            ], //[List<Widget>] - List of swipeable widgets
            startIndex: 0, //[int] - the starting index of the swipeable widgets
            onPageChanges: (
              netDragDistance,
              pagesLength,
              currentIndex,
              slideDirection,
            ) {
              //1) [pagesLength] The drage distance from swipping
              //2) [pagesLength] The length of the swipeable widgets
              //3) [currentIndex] The currect index
              //4) [slideDirection] The slide direction
            },
            // buildHeader:(context, netDragDistance, pagesLength, currentIndex, setIndex, slideDirection){
            //   //Use this to build a header in your onboarding that will display at all times. (Used to build routing buttons, indicators, etc)
            //   //This is same as onPageChanges but with [setIndex] added to allow u to change the index from this header
            // },
            buildFooter: (
              context,
              netDragDistance,
              pagesLength,
              currentIndex,
              setIndex,
              slideDirection,
            ) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (currentIndex != pagesLength - 1)
                      TextButton(
                        onPressed: () => setIndex(pagesLength - 1),
                        child: const Text("Skip"),
                      ),
                    if (currentIndex == pagesLength -1)
                      SizedBox(width: 110),
                    Row(
                      children: List.generate(
                        pagesLength,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                index == currentIndex ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (currentIndex < pagesLength - 1) {
                          setIndex(currentIndex + 1);
                        } else {
                          Get.offNamed(AppPages.loginPage);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 12,
                        ),
                        textStyle: TextStyle(fontSize: 16,),
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        currentIndex == pagesLength - 1 ? 'Get Started' : 'Next',
                      ),
                    ),
                  ],
                ),
              );
            },
            animationInMilliseconds: 500, //[int] - the speed of animations in ms
          ),
        ),
      ),
    );
  }
}

