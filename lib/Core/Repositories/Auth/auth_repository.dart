abstract class AuthRepository {
  Future<Map<String, dynamic>> setHeaders();
  Future<bool> registerDevice(String token);
  Future<dynamic> signin(context, dynamic data, bool isResponder);
  Future<dynamic> signup(context, dynamic data, bool isResponder);
  Future<dynamic> sendOtp(context, dynamic data);
  Future<dynamic> verifyOtp(context, dynamic data);
  // Future<dynamic> subscribePushNotification(context, dynamic data);
  // Future<dynamic> testPushNotification(context, dynamic data);
}
