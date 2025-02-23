
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils.enum/OnboardingPosition.dart';

class OnboardingChildPage extends StatelessWidget {
  const OnboardingChildPage({super.key, required this.onboardingPagePosition, required this.nextOnPressed});
  final OnboardingPagePosition onboardingPagePosition;
  final VoidCallback nextOnPressed;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color(0xFF1483C2), // Màu nền xanh
      body: SafeArea(
        child:_choose(),
      ),
    );
  }
  // Widget _chooseone(){
  //   if(onboardingPagePosition == OnboardingPagePosition.page1){
  //     return _buildpage1();
  //   }
  //   else return _buildotherpage();
  // }
  Widget _choose(){
    if(onboardingPagePosition == OnboardingPagePosition.page1){
      return _buildpage1();
    }
    else return _buildotherpage();
  }
  Widget _buildpage1(){
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 110,
              child: _buildshadow()
          ),
          Column(
            children: [
              SizedBox(height: 50), // Khoảng cách từ trên xuống
              _buildTitle(),
              _buildVectorDecoration(),
              Expanded(child: _buildImageBackground()),
              _buildPageIndicator(),
              SizedBox(height: 20),
              _buildGetStartedButton(),
            ],
          ),
          _buildNikeShoe(100),

          // Ảnh Nike đè lên các phần khác
        ],
      ),
    );
  }
  Widget _buildotherpage(){
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Column(
                children: [
                  _buildmiddlepicture(),
                  _buildshadow(),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              // color: Colors.black,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _buildTitle(),
                  _buildNikeShoe(0),
                ],
              ),
            ),
            SizedBox(height: 25,),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildPageIndicator(),
                  SizedBox(height: 50,),
                  _buildGetStartedButton()
                ],
              ),
            )

          ],
        ),
    );

  }
  Widget _buildmiddlepicture(){
    return Container(
      child: Image.asset(
            onboardingPagePosition.onboardingPageImage(),
            fit: BoxFit.fill,
      ),
    );
  }
  Widget _buildTitle() {
    return Container(
      width: 360,
      child: Column(
        children: [
          Text(
            onboardingPagePosition.onboardingPageTitle(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: "Lato"
            ),
          ),

          if(onboardingPagePosition.onboardingPageContent().toString().isNotEmpty)
            SizedBox(height: 12,),
            Text(
              onboardingPagePosition.onboardingPageContent(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: "Lato"
              ),
            ),

        ],
      ),
    );
  }


  Widget _buildVectorDecoration() {
    return Image.asset(
      "assets/images/Vector1.png", // Đường cong dưới tiêu đề
      width: 100,
    );
  }
  Widget _buildshadow(){
    return
       Container(
        child: Image.asset(
          "assets/images/shadow.png", // Đường cong dưới tiêu đề
          width: 480,
        ),
    );
  }


  Widget _buildImageBackground() {
    return Container(
      child: Image.asset(
        onboardingPagePosition.onboardingPageImage(),
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildNikeShoe(double heii) {
    return Positioned(
      bottom: heii,
        child: Image.asset(
          "assets/images/nike.png",
          fit: BoxFit.contain,
        ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDot(OnboardingPagePosition.page1 == onboardingPagePosition),
        SizedBox(width: 5),
        _buildDot(OnboardingPagePosition.page2 == onboardingPagePosition),
        SizedBox(width: 5),
        _buildDot(OnboardingPagePosition.page3 == onboardingPagePosition),
      ],
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      width: isActive ? 42 : 28,
      height: 4,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Color(0xFFFFB21A),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildGetStartedButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: nextOnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            onboardingPagePosition == OnboardingPagePosition.page1 ? "Get Started":"Next",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

