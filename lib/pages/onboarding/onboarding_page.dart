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
      description:
          "Labore do ex cillum fugiat anim nulla pariatur est. Elit laboris eiusmod ex occaecat do ea officia esse culpa.",
      title: "A Day at the Park",
      localImageSrc: "assets/1.svg",
      backgroundColor: Colors.orange[500]),
  ExplanationData(
      description:
          "Sit ullamco anim deserunt aliquip mollit id. Occaecat labore laboris magna reprehenderit sint in sunt ea.",
      title: "Playing Fetch",
      localImageSrc: "assets/2.svg",
      backgroundColor: Colors.orange[700]),
  ExplanationData(
      description:
          "Eiusmod aliqua laboris duis eiusmod ea ea commodo dolore. Ullamco nulla nostrud et officia.",
      title: "Relaxing Walk",
      localImageSrc: "assets/3.svg",
      backgroundColor: Colors.green[800]),
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
    return Container(
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
                      flex: 4,
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(data.length,
                                  (index) => createCircle(index: index)),
                            ),
                          ),
                          BottomButtons(
                            currentIndex: _currentIndex,
                            dataLength: data.length,
                            controller: _controller,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
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
        border: Border.all(color: Colors.blueGrey),
        color: _currentIndex == index ? Colors.blueGrey : Colors.transparent,
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
          margin: EdgeInsets.only(top: 24, bottom: 16),
          child: kIsWeb
              ? SvgPicture.asset(data.localImageSrc,
                  height: MediaQuery.of(context).size.height * 0.33,
                  alignment: Alignment.center)
              : SvgPicture.asset(data.localImageSrc,
                  height: MediaQuery.of(context).size.height * 0.33,
                  alignment: Alignment.center),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data.title,
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 48),
                child: Text(
                  data.description,
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.center,
                ),
              )
            ],
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
                width: width * 0.40,
                height: 50.0,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey[400],
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
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
              )
            ]
          : [
              TextButton(
                onPressed: () {
                  stateOnboarding.changeOnboarding();
                  /*...*/
                },
                child: Text(
                  "Skip",
                  style: Theme.of(context).textTheme.bodyText1,
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
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.arrow_right_alt,
                      color: Colors.white,
                    ),
                  )
                ],
              )
            ],
    );
  }
}
