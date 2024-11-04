
class EmergencyRequest {
    String? location;
    String? emergencyType;
    String? severity;
    String? description;
    String? locationName;
    List<String>? photos;

    EmergencyRequest({
         this.location,
         this.emergencyType,
         this.severity,
         this.description,
         this.photos,
         this.locationName
    });

    factory EmergencyRequest.fromJson(Map<String, dynamic> json) => EmergencyRequest(
        location: json["location"],
        emergencyType: json["emergencyType"],
        severity: json["severity"],
        description: json["description"],
        locationName: json['locationName'],
        photos:json["photos"] != null ? List<String>.from(json["photos"].map((x) => x)): null,
    );

    Map<String, dynamic> toJson() => {
        "location": location,
        "emergencyType": emergencyType,
        "severity": severity,
        "description": description,
        "photos":photos != null? List<dynamic>.from(photos!.map((x) => x)): null,
        "locationName":locationName
    };
}
