import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaker_shop/Presentation/Features/Login/LoginScreen.dart';

import '../utils.enum/OnboardingPosition.dart';
import 'Onboardingchildpage.dart';

class OnboardingPageView extends StatefulWidget {
  const OnboardingPageView({super.key});

  @override
  State<OnboardingPageView> createState() => _OnboardingPageViewState();
}

class _OnboardingPageViewState extends State<OnboardingPageView> {
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(//di chuểnn giũa các màn hình với nhau
        controller: _pageController,
        children: [
          OnboardingChildPage(
            onboardingPagePosition: OnboardingPagePosition.page1,
            nextOnPressed: (){
              _pageController.jumpToPage(1);
            },
          ),
          OnboardingChildPage(
            onboardingPagePosition: OnboardingPagePosition.page2,
            nextOnPressed: (){
              _pageController.jumpToPage(2);
            },
          ),
          OnboardingChildPage(
            onboardingPagePosition: OnboardingPagePosition.page3,
            nextOnPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder:(context)=> Loginscreen(isFirstTimeInstallApp: true,)),
              );
              _markOnboardingCompleted();
              _goToLoginScreen();
            },
          ),
        ],

      ),
    );
  }
  void _goToLoginScreen()
  {
    Navigator.push(context,
      MaterialPageRoute(builder:(context)=> Loginscreen(isFirstTimeInstallApp: true,)),
    );
  }
  Future<void> _markOnboardingCompleted()async{
    try{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final result = prefs.setBool("kOnboardingCompleted",true);
    }
    catch(e)
    {
      print(e);
      return;
    }
  }

}
