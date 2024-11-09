// To parse this JSON data, do

class TutorialModel {
    int status;
    Data data;

    TutorialModel({
        required this.status,
        required this.data,
    });

    factory TutorialModel.fromJson(Map<String, dynamic> json) => TutorialModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
    };
}

class Data {
    List<Tutorial> tutorials;

    Data({
        required this.tutorials,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        tutorials: List<Tutorial>.from(json["tutorials"].map((x) => Tutorial.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "tutorials": List<dynamic>.from(tutorials.map((x) => x.toJson())),
    };
}

class Tutorial {
    String id;
    String title;
    DateTime createdAt;
    DateTime updatedAt;
    int v;
    String image;

    Tutorial({
        required this.id,
        required this.title,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
        required this.image,
    });

    factory Tutorial.fromJson(Map<String, dynamic> json) => Tutorial(
        id: json["_id"],
        title: json["title"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "image": image,
    };
}
