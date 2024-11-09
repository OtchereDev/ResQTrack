
class QuizesResponse {
    int status;
    Data data;

    QuizesResponse({
        required this.status,
        required this.data,
    });

    factory QuizesResponse.fromJson(Map<String, dynamic> json) => QuizesResponse(
        status: json["status"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
    };
}

class Data {
    List<Quize> quizes;

    Data({
        required this.quizes,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        quizes: List<Quize>.from(json["quizes"].map((x) => Quize.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "quizes": List<dynamic>.from(quizes.map((x) => x.toJson())),
    };
}

class Quize {
    String id;
    String title;
    String description;
    String image;
    DateTime createdAt;
    DateTime updatedAt;

    Quize({
        required this.id,
        required this.title,
        required this.description,
        required this.image,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Quize.fromJson(Map<String, dynamic> json) => Quize(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "image": image,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}
