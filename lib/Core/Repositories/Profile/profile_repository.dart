

abstract class ProfileRepository {
  Future<dynamic> changePin(context, dynamic data);
  Future<dynamic> verifyForgotOtp(context, dynamic data);
  Future<dynamic> changePassword(context, dynamic data);
  Future<dynamic> forgotPassword(context, dynamic data);
  Future<dynamic> updateProfile(context, dynamic data);
}
