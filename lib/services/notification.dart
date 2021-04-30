import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationService extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //initilize

  Future initialize() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("ic_launcher");

    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidInitializationSettings,
            iOS: iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  //initilize timezones
  Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  //Instant Notifications
  // Future instantNofitication() async {
  //   var android = AndroidNotificationDetails("id", "channel", "description");

  //   var ios = IOSNotificationDetails();

  //   var platform = new NotificationDetails(android: android, iOS: ios);

  //   await _flutterLocalNotificationsPlugin.show(
  //       0, "Demo instant notification", "Tap to do something", platform,
  //       payload: "Welcome to demo app");
  // }

  //Sheduled Notification
  //! https://stackoverflow.com/questions/64580797/showing-notifications-using-flutter
  Future sheduledNotification() async {
    //var interval = RepeatInterval.everyMinute;
    //var bigPicture = BigPictureStyleInformation(
    //   DrawableResourceAndroidBitmap("ic_launcher"),
    //   largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
    //   contentTitle: "Demo image notification",
    //   summaryText: "This is some text",
    //   htmlFormatContent: true,
    //   htmlFormatContentTitle: true);
    var dateTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 19, 53, 0);

    var android = AndroidNotificationDetails(
      'channelId',
      'channelName',
      'channelDescription',
      color: Colors.red,
      importance: Importance.high,
      priority: Priority.high,
    );

    var platform = NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Expenses',
      'Don`t forget to update your expenses!',
      tz.TZDateTime.from(dateTime, tz.local),
      platform,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      // matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOfTenAM(TimeOfDay selectedTime) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
        now.day, selectedTime.hour, selectedTime.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> scheduleDailyTenAMNotification(TimeOfDay selectedTime) async {
    var android = AndroidNotificationDetails(
      'channelId',
      'channelName',
      'channelDescription',
      color: Colors.red,
      importance: Importance.high,
      priority: Priority.high,
    );
    var platform = NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Expenses - daily notification',
      'Don`t forget to update your expenses!',
      _nextInstanceOfTenAM(selectedTime),
      platform,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  //Cancel notification
  Future cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
