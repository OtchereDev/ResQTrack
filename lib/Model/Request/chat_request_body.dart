

class ChatMessage {
    String message;
    String userType;
    String time;

    ChatMessage({
        required this.message,
        required this.userType,
        required this.time,
    });

    factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        message: json["message"],
        userType: json["user_type"],
        time: json["time"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "user_type": userType,
        "time": time,
    };
}
