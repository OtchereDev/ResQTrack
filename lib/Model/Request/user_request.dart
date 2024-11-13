

class UserRequest {
    String? name;
    String? email;
    String? phoneNumber;
    String? password;
    String? type;
    EmergencyContact?  emergencyContact;

    UserRequest({
        this.name,
        this.email,
        this.phoneNumber,
        this.password,
        this.emergencyContact,
        this.type
    });

    factory UserRequest.fromJson(Map<String, dynamic> json) => UserRequest(
        name: json["name"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        password: json["password"],
        type: json['type'],
        emergencyContact: EmergencyContact.fromJson(json["emergencyContact"]),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
        "password": password,
        "type":type,
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




class ResponderRequest {
    String? name;
    String? email;
    String? phoneNumber;
    String? password;
    String? type;

    ResponderRequest({
        this.name,
        this.email,
        this.phoneNumber,
        this.password,
        this.type
    });

    factory ResponderRequest.fromJson(Map<String, dynamic> json) => ResponderRequest(
        name: json["name"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        password: json["password"],
        type: json['type'],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
        "password": password,
        "type":type,
    };
}
