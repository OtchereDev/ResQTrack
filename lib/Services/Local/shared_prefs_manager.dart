import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefManager {
  final String authToken = "auth_token";
  final String baseCurrency = "base_currency";
  final String getStarted = 'get_started';
  final firstTime = "firstTimeUser";
  // final String user_id = "user_id";

//set data into shared preferences like this
  Future<void> setAuthToken(String token) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(authToken, token);
  }

  Future<String> getCurrency() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(baseCurrency) ?? "";
  }

  // Future<User?> getUser() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   var user = preferences.getString('user');
  //   if (user == null) {
  //     return null;
  //   }
  //   return User.fromJson(jsonDecode(user));
  // }

  Future<String> getAuthToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? newToken;
    newToken = pref.getString(authToken) ?? "";
    return newToken;
  }

  getPushNotificationToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('pushNotificationToken');
    return token;
  }

  setPushNotificationToken(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('pushNotificationToken', token);
  }

  Future<bool> isAuthenticated() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? phone = pref.getString(authToken);
    if (phone != null) {
      return true;
    }
    return false;
  }

    Future<bool> getUserType() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool('switch_account') ?? false;
  }

    setUserType(bool patient) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('switch_account', patient);
  }

  setFirstTimeUser(bool firstime) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(firstTime, firstime);
  }

  Future<bool> isFirstTimeUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool? phone = pref.getBool(firstTime);
    
    return phone?? false;
  }
  shouldShowAppTutorials() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final result = preferences.getBool("show_tutorials_flag");
    if (result != null) {
      return result;
    } else {
      return true;
    }
  }

  setGetStarted(bool set) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var phone = pref.setBool(getStarted, set);
    return phone;
  }

  Future<bool> getGetstarted() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final result = preferences.getBool(getStarted);
    return result ?? false;
  }

  setshouldShowAppTutorials(bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool("show_tutorials_flag", value);
  }

  // setUser(User user) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   preferences.setString('user', jsonEncode(user.toJson()));
  // }

  Future<void> logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
