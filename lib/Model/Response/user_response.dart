

class UserResponse {
    String? accessToken;
    User? user;
    User? emergencyContact;

    UserResponse({
         this.accessToken,
         this.user,
         this.emergencyContact,
    });

    factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        accessToken: json["access_token"],
        user: User.fromJson(json["user"]),
        emergencyContact: User.fromJson(json["emergency_contact"]),
    );

    Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "user": user?.toJson(),
        "emergency_contact":emergencyContact?.toJson()
    };
}

class User {
    String? id;
    String? name;
    String? phoneNumber;
    String? email;
    String? user;
    DateTime? createdAt;
    DateTime? updatedAt;

    User({
         this.id,
         this.name,
         this.phoneNumber,
         this.email,
         this.user,
         this.createdAt,
         this.updatedAt,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
        user: json["user"],
        // createdAt: DateTime.parse(json["createdAt"]),
        // updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "phoneNumber": phoneNumber,
        "email": email,
        "user":user
        // "createdAt": createdAt?.toIso8601String(),
        // "updatedAt": updatedAt?.toIso8601String(),
    };
}
