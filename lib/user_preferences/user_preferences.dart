import 'package:products/pages/login_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

/* Add to main: 

WidgetsFlutterBinding.ensureInitialized();

final prefs = new UserPreferences();
await prefs.initPrefs();

*/

class UserPreferences {
  /// Singleton (to use the same instance everywhere in the app)
  static final UserPreferences _instance = new UserPreferences._();

  /// Default constructor returns the singleton
  factory UserPreferences() {
    return _instance;
  }

  /// Private constructor for singleton
  UserPreferences._();

  SharedPreferences? _prefs;

  // Called before running the app
  Future<void> initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GETTERS and SETTERS
  String get token {
    // If gender is null return 1
    return _prefs!.getString('token') ?? '';
  }

  set token(String value) {
    _prefs!.setString('token', value);
  }

  String get lastPage {
    return _prefs!.getString('lastPage') ?? LoginPage.routeName;
  }

  set lastPage(String value) {
    _prefs!.setString('lastPage', value);
  }
}
