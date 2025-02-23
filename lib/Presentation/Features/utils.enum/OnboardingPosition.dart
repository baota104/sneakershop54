enum OnboardingPagePosition
{
  page1,
  page2,
  page3;

}
extension OnboardingPositionExtention on OnboardingPagePosition
{
  String onboardingPageImage()
  {
    switch (this) {
      case OnboardingPagePosition.page1:
        return "assets/images/onboard1.png";
      case OnboardingPagePosition.page2:
        return "assets/images/onboard2.png";
      case OnboardingPagePosition.page3:
        return "assets/images/onboard3.png";
    }
  }
  String onboardingPageTitle() {
    switch (this) {
      case OnboardingPagePosition.page1:
        return "WELCOME TO TWOSNEAKER";
      case OnboardingPagePosition.page2:
        return "Let’s Start Journey With our Sneakers";
      case OnboardingPagePosition.page3:
        return "You Have the Power To do it";
    }
  }
  String onboardingPageContent() {
    switch (this) {
      case OnboardingPagePosition.page1:
        return "";
      case OnboardingPagePosition.page2:
        return "Smart, Gorgeous & Fashionable Collection Explor Now";
      case OnboardingPagePosition.page3:
        return "There Are Many Beautiful And Attractive Plants To Your Room";
    }
  }

}