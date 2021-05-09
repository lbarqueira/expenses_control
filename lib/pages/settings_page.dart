import 'package:animations/animations.dart';
import 'package:expenses_control/providers/login_state.dart';
import 'package:expenses_control/providers/theme_state.dart';
import 'package:expenses_control/services/notification.dart';
import 'package:expenses_control/utils/avatar.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TimeOfDay _time = TimeOfDay.now();
  //bool _activeNotifications = false;
  bool _activeNotifications; //!new
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance(); //! New
  String _timeNotifications; //!new

  void setupNotificationPlugin() async {
    await Provider.of<NotificationService>(context, listen: false)
        .initialize(); // ! initialize
    Provider.of<NotificationService>(context, listen: false)
        .configureLocalTimeZone();
  }

//! New
  Future<void> getPrefNotification() async {
    await _prefs.then((SharedPreferences prefs) {
      var activeNotifications = prefs.getBool('ActiveNotifications') ?? false;
      var timeNotifications = prefs.getString('TimeNotifications') ?? '--:--';
      setState(() {
        _activeNotifications = activeNotifications;
        _timeNotifications = timeNotifications;
      });
    });
  }

  Future<void> _saveToPrefs() async {
    await _prefs.then((SharedPreferences prefs) {
      prefs.setBool('ActiveNotifications', false);
      prefs.setString('TimeNotifications', _timeNotifications);
    });
  }

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      setupNotificationPlugin();
      getPrefNotification(); //! New
      print('initState_activeNotifications = $_activeNotifications');
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<LoginState>(context, listen: false).currentUser;

    Future<void> _selectTime() async {
      final TimeOfDay newTime =
          await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (newTime != null) {
        await _prefs.then((SharedPreferences prefs) {
          prefs.setBool('ActiveNotifications', true);
          prefs.setString('TimeNotifications', newTime.format(context));
          setState(() {
            //       _activeNotifications = true;
            _activeNotifications = true; //!new
            _timeNotifications = newTime.format(context); //!new
          });
          _time = newTime;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Profile & Settings',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
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
          if (!kIsWeb && _activeNotifications != null)
            Container(
              child: Center(
                child: Consumer<NotificationService>(
                  builder: (BuildContext context, model, _) {
                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ElevatedButton(
                          style: (_activeNotifications)
                              ? ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.grey),
                                )
                              : null,
                          onPressed: (!_activeNotifications)
                              ? () async {
                                  await _selectTime();
                                  print('${_time.format(context)}');
                                  print('$_activeNotifications');
                                  model.scheduleDailyTenAMNotification(_time);
                                }
                              : () {},
                          child: (_activeNotifications)
                              ? Text(
                                  'Notification active for $_timeNotifications')
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
                              _saveToPrefs();
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
          if (!kIsWeb && _activeNotifications == null)
            Expanded(child: Container()),
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
                showModal(
                  context: context,
                  configuration: FadeScaleTransitionConfiguration(
                      barrierDismissible: false),
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
