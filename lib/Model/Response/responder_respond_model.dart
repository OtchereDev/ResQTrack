

class ResponderRequestModel {
    int? status;
    Emergency? emergency;

    ResponderRequestModel({
         this.status,
         this.emergency,
    });

    factory ResponderRequestModel.fromJson(Map<String, dynamic> json) => ResponderRequestModel(
        status: json["status"],
        emergency:json["emergency"] != null ? Emergency.fromJson(json["emergency"]): null,
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "emergency": emergency?.toJson(),
    };
}

class Emergency {
    Location? location;
    String? id;
    String? user;
    String? description;
    String? status;
    String? emergencyType;
    String? severity;
    String? locationName;
    List<String>? photos;
    DateTime? retryTime;
    List<dynamic>? textEmbedding;
    List<dynamic>? imageEmbedding;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? responder;

    Emergency({
        this.location,
        this.id,
        this.user,
        this.description,
        this.status,
        this.emergencyType,
        this.severity,
        this.locationName,
        this.photos,
        this.retryTime,
        this.textEmbedding,
        this.imageEmbedding,
        this.createdAt,
        this.updatedAt,

         this.responder,
    });

    factory Emergency.fromJson(Map<String, dynamic> json) => Emergency(
        location: Location.fromJson(json["location"]),
        id: json["_id"],
        user: json["user"],
        description: json["description"],
        status: json["status"],
        emergencyType: json["emergencyType"],
        severity: json["severity"],
        locationName: json["locationName"],
        photos: List<String>.from(json["photos"].map((x) => x)),
        retryTime: DateTime.parse(json["retryTime"]),
        // textEmbedding: List<dynamic>.from(json["textEmbedding"].map((x) => x)),
        // imageEmbedding: List<dynamic>.from(json["imageEmbedding"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        responder: json["responder"],
    );

    Map<String, dynamic> toJson() => {
        "location": location?.toJson(),
        "_id": id,
        "user": user,
        "description": description,
        "status": status,
        "emergencyType": emergencyType,
        "severity": severity,
        "locationName": locationName,
        "photos": List<dynamic>.from(photos!.map((x) => x)),
        "retryTime": retryTime?.toIso8601String(),
        // "textEmbedding": List<dynamic>.from(textEmbedding!.map((x) => x)),
        // "imageEmbedding": List<dynamic>.from(imageEmbedding!.map((x) => x)),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "responder": responder,
    };
}

class Location {
    String? type;
    List<double>? coordinates;

    Location({
         this.type,
         this.coordinates,
    });

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json["type"],
        coordinates: List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates!.map((x) => x)),
    };
}
