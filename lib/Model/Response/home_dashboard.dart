

class HomeMetrics {
    Metric metric;

    HomeMetrics({
        required this.metric,
    });

    factory HomeMetrics.fromJson(Map<String, dynamic> json) => HomeMetrics(
        metric: Metric.fromJson(json["metric"]),
    );

    Map<String, dynamic> toJson() => {
        "metric": metric.toJson(),
    };
}

class Metric {
    int numberOfEmergency;
    int accumulatedResponseTime;
    int accumulatedOnSceneTime;
    int accumulatedTurnaroundTime;
    int numberOfArrest;
    int numberOfEscape;
    int numberOfFirePutOut;
    int numberOfFireNotPutOut;
    int numberOfLiveSaved;
    int numberOfDeath;
    String responder;
    String id;
    DateTime createdAt;
    DateTime updatedAt;
    int v;

    Metric({
        required this.numberOfEmergency,
        required this.accumulatedResponseTime,
        required this.accumulatedOnSceneTime,
        required this.accumulatedTurnaroundTime,
        required this.numberOfArrest,
        required this.numberOfEscape,
        required this.numberOfFirePutOut,
        required this.numberOfFireNotPutOut,
        required this.numberOfLiveSaved,
        required this.numberOfDeath,
        required this.responder,
        required this.id,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    factory Metric.fromJson(Map<String, dynamic> json) => Metric(
        numberOfEmergency: json["numberOfEmergency"],
        accumulatedResponseTime: json["accumulatedResponseTime"],
        accumulatedOnSceneTime: json["accumulatedOnSceneTime"],
        accumulatedTurnaroundTime: json["accumulatedTurnaroundTime"],
        numberOfArrest: json["numberOfArrest"],
        numberOfEscape: json["numberOfEscape"],
        numberOfFirePutOut: json["numberOfFirePutOut"],
        numberOfFireNotPutOut: json["numberOfFireNotPutOut"],
        numberOfLiveSaved: json["numberOfLiveSaved"],
        numberOfDeath: json["numberOfDeath"],
        responder: json["responder"],
        id: json["_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "numberOfEmergency": numberOfEmergency,
        "accumulatedResponseTime": accumulatedResponseTime,
        "accumulatedOnSceneTime": accumulatedOnSceneTime,
        "accumulatedTurnaroundTime": accumulatedTurnaroundTime,
        "numberOfArrest": numberOfArrest,
        "numberOfEscape": numberOfEscape,
        "numberOfFirePutOut": numberOfFirePutOut,
        "numberOfFireNotPutOut": numberOfFireNotPutOut,
        "numberOfLiveSaved": numberOfLiveSaved,
        "numberOfDeath": numberOfDeath,
        "responder": responder,
        "_id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}
