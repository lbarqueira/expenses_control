import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/login_state.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Image.asset('assets/login_background.png',
                height: MediaQuery.of(context).size.height * 0.33,
                alignment: Alignment.center),
          ),
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
        ],
      ),
    );
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
