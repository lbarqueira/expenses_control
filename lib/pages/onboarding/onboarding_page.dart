import 'package:expenses_control/providers/onboarding_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ExplanationData {
  final String title;
  final String description;
  final String localImageSrc;
  final Color backgroundColor;

  ExplanationData(
      {this.title, this.description, this.localImageSrc, this.backgroundColor});
}

final List<ExplanationData> data = [
  ExplanationData(
      description: 'Easy to use, only the most-used expense categories.',
      title: 'Easy to Use',
      localImageSrc: kIsWeb ? 'Group15.svg' : 'assets/Group15.svg',
      backgroundColor: Color(0xfff0f0f0)),
  ExplanationData(
      description:
          'Month and annual data presented through Line and Pie Charts.',
      title: 'Easy to Visualize',
      localImageSrc: kIsWeb ? 'Group6.svg' : 'assets/Group6.svg',
      backgroundColor: Color(0xfff0f0f0)),
  ExplanationData(
      description:
          'Choose to be notified every day so you do not forget to add expenses.',
      title: 'Easy to Remember',
      localImageSrc: kIsWeb ? 'Group10.svg' : 'assets/Group10.svg',
      backgroundColor: Color(0xfff0f0f0)),
];

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: data[_currentIndex].backgroundColor,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(16),
            color: data[_currentIndex].backgroundColor,
            alignment: Alignment.center,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      Expanded(
                        flex: 7,
                        child: Container(
                            alignment: Alignment.center,
                            child: PageView(
                                scrollDirection: Axis.horizontal,
                                controller: _controller,
                                onPageChanged: (value) {
                                  setState(() {
                                    _currentIndex = value;
                                  });
                                },
                                children: data
                                    .map((e) => ExplanationPage(data: e))
                                    .toList())),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(data.length,
                                (index) => createCircle(index: index)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BottomButtons(
                              currentIndex: _currentIndex,
                              dataLength: data.length,
                              controller: _controller,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  createCircle({int index}) {
    return AnimatedContainer(
      curve: Curves.linear,
      duration: Duration(milliseconds: 250),
      margin: EdgeInsets.only(right: 10),
      height: _currentIndex == index ? 8 : 8,
      width: _currentIndex == index ? 8 : 8,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        color: _currentIndex == index
            ? Theme.of(context).colorScheme.primary
            : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class ExplanationPage extends StatelessWidget {
  final ExplanationData data;

  ExplanationPage({this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: kIsWeb
              ? SvgPicture.asset(data.localImageSrc,
                  height: MediaQuery.of(context).size.height * 0.33,
                  alignment: Alignment.center)
              : SvgPicture.asset(data.localImageSrc,
                  height: MediaQuery.of(context).size.height * 0.33,
                  alignment: Alignment.center),
        ),
        Expanded(
          child: Container(),
        ),
        Expanded(
          child: Container(
            child: Text(
              data.title,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primaryVariant,
                  fontSize: 32.0),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              data.description,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primaryVariant,
                  fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

class BottomButtons extends StatelessWidget {
  final int currentIndex;
  final int dataLength;
  final PageController controller;

  const BottomButtons(
      {Key key, this.currentIndex, this.dataLength, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: use consumer instead of provider.of
    var stateOnboarding = Provider.of<OnboardingNotifier>(context);
    double width = MediaQuery.of(context).size.width;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: currentIndex == dataLength - 1
          ? MainAxisAlignment.spaceAround
          : MainAxisAlignment.spaceBetween,
      children: currentIndex == dataLength - 1
          ? [
              Container(
                width: width * 0.50,
                height: 40.0,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                        side: BorderSide.none),
                  ),
                  onPressed: () {
                    stateOnboarding.changeOnboarding();
                  },
                  child: Container(
                    child: Text(
                      "Get started",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              )
            ]
          : [
              TextButton(
                onPressed: () {
                  stateOnboarding.changeOnboarding();
                },
                child: Text(
                  "Skip",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      controller.nextPage(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeInOut);
                    },
                    child: Text(
                      "Next",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.arrow_right_alt,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                ],
              )
            ],
    );
  }
}
