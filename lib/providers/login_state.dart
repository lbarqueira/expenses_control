import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginState with ChangeNotifier {
  bool _loggedIn; //! false
  bool _loading = false;
  User _user;

  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferences _prefs;

  LoginState() {
    loginState();
  }

  bool get isLoggedIn => _loggedIn;

  bool get isLoading => _loading;

  User get currentUser => _user;

  void login(BuildContext context) async {
    _loading = true;
    notifyListeners();

    _user = await _handleSignIn(context);
    _loading = false;

    if (_user != null) {
      _prefs.setBool('isLoggedIn', true);
      _loggedIn = true;
      notifyListeners();
    } else {
      _loggedIn = false;
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    // _prefs.clear(); - with this code I was cleaning all states keeped with shared preferences
    _prefs.remove('isLoggedIn');
    await signOut(context);
    _loggedIn = false;
    notifyListeners();
  }

  Future<void> signOut(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut().catchError(
          (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error signing out: ${e.code}'),
                duration: Duration(seconds: 5),
              ),
            );
          },
        );
      }
      await _auth.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error signing out. Try again'),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Future<User> _handleSignIn(context) async {
    User user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await _auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed with error code: ${e.code}'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn().catchError(
        (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed due to: ${e.code}'),
              duration: Duration(days: 365),
              // duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Cancel',
                onPressed: () {},
              ),
            ),
          );
        },
      );

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        try {
          final UserCredential userCredential =
              await _auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            // handle the error here
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed with error code: ${e.code}'),
                duration: const Duration(seconds: 5),
              ),
            );
          } else if (e.code == 'invalid-credential') {
            // handle the error here
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed with error code: ${e.code}'),
                duration: const Duration(seconds: 5),
              ),
            );
          }
        } catch (e) {
          // handle the error here}
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed with error code: ${e.code}'),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    }
//    print('signed in ' + user.displayName);
    return user;
  }

  void loginState() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey('isLoggedIn')) {
      _user = _auth.currentUser;
      _loggedIn = _user != null;

      _loading = false;
      notifyListeners();
    } else {
      _loggedIn = false; //! new code
      _loading = false;
      notifyListeners();
    }
  }
}
