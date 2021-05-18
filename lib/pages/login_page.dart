import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/login_state.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TapGestureRecognizer _recognizer1;
  TapGestureRecognizer _recognizer2;

  void showHelp(String s) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(s),
        actions: <Widget>[
          TextButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _recognizer1 = TapGestureRecognizer()
      ..onTap = () {
        showHelp(
            'Terms of Service: ...... is provided AS IS and has no current warranty on how the'
            ' data and uptime is managed. The final terms will be released when the final version of the app'
            ' will be released.');
      };
    _recognizer2 = TapGestureRecognizer()
      ..onTap = () {
        showHelp(
            'Privacy Policy: .......All your data is saved anonymously on Firebase Firestore database and will be remain that way.'
            ' no other users will have access to it.');
      };
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Text(
            'Monthly Expenses',
            style: TextStyle(
              fontSize: width * 0.08,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Image.asset('assets/login_background.png',
                height: MediaQuery.of(context).size.height * 0.33,
                alignment: Alignment.center),
          ),
//          Text(
//            'My personal finance overview',
//            style: Theme.of(context).textTheme.caption,
//          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Center(
            child: Consumer<LoginState>(
              builder: (BuildContext context, LoginState value, Widget child) {
                if (value.isLoading) {
                  return CircularProgressIndicator();
                } else {
                  return child;
                }
              },
              child: GoogleSignUpButtonWidget(
                width: width * 0.60,
                content: 'Continue with Google',
                onPressed: () {
                  Provider.of<LoginState>(context, listen: false)
                      .login(context);
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyText2,
                text: 'To use this app you need to agree to our ',
                children: [
                  TextSpan(
                    text: 'Terms of Service',
                    recognizer: _recognizer1,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    recognizer: _recognizer2,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _recognizer1.dispose();
    _recognizer2.dispose();
  }
}

class GoogleSignUpButtonWidget extends StatelessWidget {
  final void Function() onPressed;
  final String content;
  final double width;
  const GoogleSignUpButtonWidget({
    Key key,
    this.onPressed,
    this.content,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      width: width,
      child: TextButton.icon(
        icon: Icon(
          FontAwesomeIcons.google,
          color: Color(0xffb00020),
          size: 24.0,
        ),
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100), side: BorderSide.none),
        ),
        label: Text(
          content,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14.0,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
