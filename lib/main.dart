import 'package:expenses_control/providers/login_state.dart';
import 'package:flutter/material.dart';
import 'package:expenses_control/pages/home_page.dart';
import 'package:expenses_control/pages/login_page.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/details_page.dart';
import 'pages/onboarding/onboarding_page.dart';
import 'pages/settings_page.dart';
import 'providers/onboarding_state.dart';
import 'providers/theme_state.dart';
import 'services/notification.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //! disable Landscape mode in Flutter
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  await Firebase.initializeApp();
  await SharedPreferences.getInstance().then(
    (prefs) {
      var isDarkTheme = prefs.getBool('darkTheme') ?? true;
      print('isDarkTheme = $isDarkTheme');
      print('prefs = $prefs');
      return runApp(
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(isDarkTheme, prefs), //! prefs
          child: MyApp(),
        ),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginState>(
          create: (_) => LoginState(),
        ),
        ChangeNotifierProvider<OnboardingNotifier>(
          create: (_) => OnboardingNotifier(),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationService(),
        )
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, notifier, child) {
          debugPrint('notifier.darkTheme = ${notifier.darkTheme}');
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: notifier.darkTheme ? ThemeMode.dark : ThemeMode.light,
            onGenerateRoute: (settings) {
              if (settings.name == '/details') {
                DetailsParams params = settings.arguments;
                return MaterialPageRoute(
                  builder: (BuildContext context) {
                    return DetailsPage(
                      params: params,
                    );
                  },
                );
              } else if (settings.name == '/settings') {
                return MaterialPageRoute(
                  builder: (BuildContext context) {
                    return SettingsPage();
                  },
                );
              }
              return null;
            },
            routes: {
              '/': (context) {
                return Consumer<OnboardingNotifier>(
                  builder: (context, stateOnboarding, child) {
                    print('isFirstSeen = ${stateOnboarding.isFirstSeen}');
                    if (stateOnboarding.isFirstSeen != null) {
                      if (!stateOnboarding.isFirstSeen) {
                        return Consumer<LoginState>(
                          builder: (context, stateLogin, child) {
                            print('isLoggedIn = ${stateLogin.isLoggedIn}');
                            if (stateLogin.isLoggedIn != null) {
                              if (stateLogin.isLoggedIn) {
                                return HomePage();
                              } else {
                                return LoginPage();
                              }
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        );
                      } else {
                        return OnboardingPage();
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                );
              },
//              '/add': (context) => AddPage(),
            },
          );
        },
      ),
    );
  }
}
