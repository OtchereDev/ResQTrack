// To parse this JSON data, do
//
//     final emergencyResponse = emergencyResponseFromJson(jsonString);

import 'dart:convert';

EmergencyResponse emergencyResponseFromJson(String str) => EmergencyResponse.fromJson(json.decode(str));

String emergencyResponseToJson(EmergencyResponse data) => json.encode(data.toJson());

class EmergencyResponse {
    int? status;
    List<EmergencyResponseEmergency>? emergencies;

    EmergencyResponse({
         this.status,
         this.emergencies,
    });

    factory EmergencyResponse.fromJson(Map<String, dynamic> json) => EmergencyResponse(
        status: json["status"],
        emergencies: List<EmergencyResponseEmergency>.from(json["emergencies"].map((x) => EmergencyResponseEmergency.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "emergencies": List<dynamic>.from(emergencies!.map((x) => x.toJson())),
    };
}

class EmergencyResponseEmergency {
    DateTime? id;
    List<EmergencyEmergency>? emergencies;
    int? count;

    EmergencyResponseEmergency({
        required this.id,
        required this.emergencies,
        required this.count,
    });

    factory EmergencyResponseEmergency.fromJson(Map<String, dynamic> json) => EmergencyResponseEmergency(
        id: DateTime.parse(json["_id"]),
        emergencies: List<EmergencyEmergency>.from(json["emergencies"].map((x) => EmergencyEmergency.fromJson(x))),
        count: json["count"],
    );

    Map<String, dynamic> toJson() => {
        "_id": "${id?.year.toString().padLeft(4, '0')}-${id?.month.toString().padLeft(2, '0')}-${id?.day.toString().padLeft(2, '0')}",
        "emergencies": List<dynamic>.from(emergencies!.map((x) => x.toJson())),
        "count": count,
    };
}

class EmergencyEmergency {
    String? id;
    String? user;
    String? description;
    String? status;
    String? emergencyType;
    String? severity;
    Location? location;
    List<dynamic> ?photos;
    DateTime? createdAt;
    DateTime? updatedAt;
    UserDetails? userDetails;

    EmergencyEmergency({
        this.id,
        this.user,
        this.description,
        this.status,
        this.emergencyType,
        this.severity,
        this.location,
        this.photos,
        this.createdAt,
        this.updatedAt,
        this.userDetails,
    });

    factory EmergencyEmergency.fromJson(Map<String, dynamic> json) => EmergencyEmergency(
        id: json["_id"],
        user: json["user"],
        description: json["description"],
        status: json["status"],
        emergencyType: json["emergencyType"],
        severity: json["severity"],
        location: Location.fromJson(json["location"]),
        photos: List<dynamic>.from(json["photos"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),

        userDetails: UserDetails.fromJson(json["userDetails"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user,
        "description": description,
        "status": status,
        "emergencyType": emergencyType,
        "severity": severity,
        "location": location?.toJson(),
        "photos": List<dynamic>.from(photos!.map((x) => x)),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),

        "userDetails": userDetails?.toJson(),
    };
}

class Location {
    double latitude;
    double longitude;

    Location({
        required this.latitude,
        required this.longitude,
    });

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
    };
}

class UserDetails {
    String id;
    String name;
    String phoneNumber;
    String email;
    String password;
    DateTime createdAt;
    DateTime updatedAt;


    UserDetails({
        required this.id,
        required this.name,
        required this.phoneNumber,
        required this.email,
        required this.password,
        required this.createdAt,
        required this.updatedAt,

    });

    factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        id: json["_id"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
        password: json["password"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),

    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "phoneNumber": phoneNumber,
        "email": email,
        "password": password,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),

    };
}
