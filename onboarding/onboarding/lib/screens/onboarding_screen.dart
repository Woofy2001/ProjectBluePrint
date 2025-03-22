import 'package:flutter/material.dart';
import '../widgets/onboarding_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {"title": "", "subtitle": "", "image": "assets/images/logo.png"},
    {
      "title": "Welcome",
      "subtitle": "The Future of Home Design at Your Fingertips",
      "image": "assets/images/logo.png"
    },
    {
      "title": "Design Your Dream House",
      "subtitle":
          "Experience Intelligent Assistance for Custom Home Layouts and Material Choices",
      "image": "assets/images/house_1.png"
    },
    {
      "title": "Budget-Friendly Control",
      "subtitle":
          "Keep Your Design Process on Track with Real-Time Budget Adjustments and Insights",
      "image": "assets/images/budget.png"
    },
    {
      "title": "Eco-Friendly Choices",
      "subtitle":
          "Discover Eco-Friendly and Climate-Appropriate Design Solutions for Your Home",
      "image": "assets/images/eco_house.png"
    },
  ];

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      // TODO: Navigate to login/home screen
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _skip() {
    // TODO: Navigate to home screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _onboardingData.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingWidget(
                title: _onboardingData[index]["title"]!,
                subtitle: _onboardingData[index]["subtitle"]!,
                image: _onboardingData[index]["image"]!,
                showNavigation: index > 1,
                onBack: _previousPage,
                onSkip: _skip,
                onNext: _nextPage,
              );
            },
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingData.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
