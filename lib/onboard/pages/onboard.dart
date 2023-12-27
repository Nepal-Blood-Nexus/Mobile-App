import 'package:flutter/material.dart';
import 'package:nepal_blood_nexus/utils/colours.dart';
import 'package:nepal_blood_nexus/utils/routes.dart';
import 'package:onboarding/onboarding.dart';

class OnboardPage extends StatefulWidget {
  const OnboardPage({super.key});

  @override
  State<OnboardPage> createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {
  late Material materialButton;
  late int index;
  final onboardingPagesList = [
    PageModel(
      widget: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Image.asset(
                  "assets/images/bg_icon_1.png",
                  width: 180,
                ),
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
                  child: Column(
                    children: [
                      Text(
                        "Find Blood Donors",
                        style: TextStyle(
                            fontSize: 30,
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum ",
                        style: TextStyle(
                            color: Colours.white,
                            fontSize: 17,
                            locale: Locale('npl', 'NP')),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    PageModel(
      widget: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Image.asset(
                  "assets/images/bg_icon_1.png",
                  width: 180,
                ),
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
                  child: Column(
                    children: [
                      Text(
                        "Valuable Blood Insights",
                        style: TextStyle(
                            fontSize: 30,
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum ",
                        style: TextStyle(
                            color: Colours.white,
                            fontSize: 17,
                            locale: Locale('npl', 'NP')),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    PageModel(
      widget: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Image.asset(
                  "assets/images/bg_icon_1.png",
                  width: 180,
                ),
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
                  child: Column(
                    children: [
                      Text(
                        "BE A PART OF COMMUNITY",
                        style: TextStyle(
                            fontSize: 30,
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum ",
                        style: TextStyle(
                            color: Colours.white,
                            fontSize: 17,
                            locale: Locale('npl', 'NP')),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    materialButton = _skipButton();
    index = 0;
  }

  Material _skipButton({void Function(int)? setIndex}) {
    return Material(
      borderRadius: defaultSkipButtonBorderRadius,
      borderOnForeground: true,
      color: Colors.transparent,
      child: InkWell(
        borderRadius: defaultSkipButtonBorderRadius,
        onTap: () {
          if (setIndex != null) {
            index = index + 1;
            setIndex(index);
          }
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Text(
                'Next',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(
                Icons.navigate_next_rounded,
                color: Colours.white,
              )
            ],
          ),
        ),
      ),
    );
  }

  Material get _signupButton {
    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(2)),
      color: const Color.fromARGB(255, 255, 255, 255),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.login,
          );
        },
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            'Sign up',
            style: TextStyle(
                color: Colours.mainColor,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.7),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.mainColor,
      body: Onboarding(
        pages: onboardingPagesList,
        onPageChange: (int pageIndex) {
          index = pageIndex;
        },
        startPageIndex: 0,
        footerBuilder: (context, dragDistance, pagesLength, setIndex) {
          return DecoratedBox(
            decoration: const BoxDecoration(),
            child: ColoredBox(
                color: Colours.mainColor,
                child: Container(
                    // color: Colors.black,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 40, horizontal: 10),
                      child: Row(children: [
                        SizedBox(
                          width: 250,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: CustomIndicator(
                              netDragPercent: dragDistance,
                              pagesLength: pagesLength,
                              indicator: Indicator(
                                closedIndicator: const ClosedIndicator(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                                indicatorDesign: IndicatorDesign.polygon(
                                  polygonDesign: PolygonDesign(
                                      polygon: DesignType.polygon_circle,
                                      polygonSpacer: 24.0,
                                      polygonRadius: 6),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: index < onboardingPagesList.length - 1
                              ? _skipButton(setIndex: setIndex)
                              : _signupButton,
                        )
                      ]),
                    ))),
          );
        },
      ),
    );
  }
}
