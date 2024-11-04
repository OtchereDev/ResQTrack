class UserFirebaseRequest {
  String userId;
  String fcmToken;
  String name;
  String userType;

  UserFirebaseRequest(
      {required this.fcmToken,
      required this.userId,
      required this.name,
      required this.userType});

  factory UserFirebaseRequest.fromJson(Map<String, dynamic> json) =>
      UserFirebaseRequest(
          fcmToken: json["fcmToken"],
          userId: json["userID"],
          name: json["name"],
          userType: json['userType']);

  Map<String, dynamic> toJson() => {
        "userType": userType,
        "userID": userId,
        "name": name,
        "fcmToken": fcmToken,
      };
}
