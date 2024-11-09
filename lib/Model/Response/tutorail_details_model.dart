

class TutorialDetailsModel {
    int status;
    Data data;

    TutorialDetailsModel({
        required this.status,
        required this.data,
    });

    factory TutorialDetailsModel.fromJson(Map<String, dynamic> json) => TutorialDetailsModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
    };
}

class Data {
    Tutorial tutorial;

    Data({
        required this.tutorial,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        tutorial: Tutorial.fromJson(json["tutorial"]),
    );

    Map<String, dynamic> toJson() => {
        "tutorial": tutorial.toJson(),
    };
}

class Tutorial {
    String id;
    String title;
    List<String> videos;
    DateTime createdAt;
    DateTime updatedAt;
    int v;
    String image;

    Tutorial({
        required this.id,
        required this.title,
        required this.videos,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
        required this.image,
    });

    factory Tutorial.fromJson(Map<String, dynamic> json) => Tutorial(
        id: json["_id"],
        title: json["title"],
        videos: List<String>.from(json["videos"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "videos": List<dynamic>.from(videos.map((x) => x)),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "image": image,
    };
}
