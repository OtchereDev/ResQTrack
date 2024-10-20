

class UserRequest {
    String? name;
    String? email;
    String? phoneNumber;
    String? password;
    EmergencyContact?  emergencyContact;

    UserRequest({
        this.name,
        this.email,
        this.phoneNumber,
        this.password,
        this.emergencyContact,
    });

    factory UserRequest.fromJson(Map<String, dynamic> json) => UserRequest(
        name: json["name"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        password: json["password"],
        emergencyContact: EmergencyContact.fromJson(json["emergencyContact"]),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
        "password": password,
        "emergencyContact": emergencyContact?.toJson(),
    };
}

class EmergencyContact {
    String? name;
    String? email;
    String? phoneNumber;

    EmergencyContact({
         this.name,
         this.email,
         this.phoneNumber,
    });

    factory EmergencyContact.fromJson(Map<String, dynamic> json) => EmergencyContact(
        name: json["name"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
    };
}
