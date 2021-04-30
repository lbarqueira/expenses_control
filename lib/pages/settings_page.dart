import 'package:expenses_control/providers/login_state.dart';
import 'package:expenses_control/providers/theme_state.dart';
import 'package:expenses_control/services/notification.dart';
import 'package:expenses_control/utils/avatar.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TimeOfDay _time = TimeOfDay.now();
  bool _activeNotifications = false;

  void setupNotificationPlugin() async {
    await Provider.of<NotificationService>(context, listen: false)
        .initialize(); // ! initialize
    Provider.of<NotificationService>(context, listen: false)
        .configureLocalTimeZone();
  }

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      setupNotificationPlugin();
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<LoginState>(context, listen: false).currentUser;

    Future<void> _selectTime() async {
      final TimeOfDay newTime = await showTimePicker(
        context: context,
        initialTime: _time,
      );
      if (newTime != null) {
        setState(() {
          _activeNotifications = true;
          _time = newTime;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const SizedBox(height: 8),
          Avatar(
            photoUrl: user.photoURL,
            radius: 50,
          ),
          const SizedBox(height: 10),
          if (user.displayName != null)
            Text(
              user.displayName,
            ),
          const SizedBox(height: 4),
          if (user.email != null)
            Text(
              user.email,
            ),
          const SizedBox(height: 18),
          Padding(
            padding: EdgeInsets.only(left: 30.0, right: 30.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Text('Use dark mode?'),
                ),
                Consumer<ThemeNotifier>(
                  builder: (context, notifier, child) => Switch(
                    onChanged: (val) {
                      notifier.toggleTheme();
                    },
                    value: notifier.darkTheme,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
          if (!kIsWeb)
            Container(
              child: Center(
                child: Consumer<NotificationService>(
                  builder: (BuildContext context, model, _) {
                    return Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await _selectTime();
                            print('${_time.format(context)}');
                            print('$_activeNotifications');
                            model.scheduleDailyTenAMNotification(_time);
                          },
                          child: (_activeNotifications)
                              ? Text('Notification already active')
                              : Text('Schedule Notification'),
                        ),
                        SizedBox(height: 8),
                        //Text(
                        //  'Selected time: ${_time.format(context)}',
                        //),
                        if (_activeNotifications)
                          ElevatedButton(
                            onPressed: () async {
                              await model.cancelNotification();
                              print('Notification Cancelled');
                              setState(() {
                                _activeNotifications = false;
                              });
                            },
                            child: Text('Cancel Notification'),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          Expanded(
            child: Container(),
          ),
          Container(
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: MaterialButton(
              child: Text(
                "Sign Out",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Logout'),
                      content: Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          child: Text('Logout'),
                          onPressed: () async {
                            await Provider.of<LoginState>(context,
                                    listen: false)
                                .logout(context);
                            Navigator.of(context).pop(); // pop alertdialog
                            Navigator.of(context).pop(); // pop page
                          },
                        ),
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
