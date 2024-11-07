class GuideResponse {
    int? status;
    Data? data;

    GuideResponse({
         this.status,
         this.data,
    });

    factory GuideResponse.fromJson(Map<String, dynamic> json) => GuideResponse(
        status: json["status"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class Data {
    List<Guide> guides;

    Data({
        required this.guides,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        guides: List<Guide>.from(json["guides"].map((x) => Guide.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "guides": List<dynamic>.from(guides.map((x) => x.toJson())),
    };
}

class Guide {
    String? id;
    String? title;
    String? image;
    DateTime? createdAt;
    String? content;
    Category? category;

    Guide({
         this.id,
         this.title,
         this.image,
         this.createdAt,
         this.content,
         this.category,
    });

    factory Guide.fromJson(Map<String, dynamic> json) => Guide(
        id: json["_id"],
        title: json["title"],
        image: json["image"],
        createdAt: DateTime.parse(json["createdAt"]),
        content: json["content"],
        category: Category.fromJson(json["category"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "image": image,
        "createdAt": createdAt?.toIso8601String(),
        "content": content,
        "category": category?.toJson(),
    };
}

class Category {
    String? id;
    String? name;

    Category({
         this.id,
         this.name,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name
    };
}
