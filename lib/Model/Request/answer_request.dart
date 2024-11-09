
class AnswerResponse {
    List<Answer> answers;

    AnswerResponse({
        required this.answers,
    });

    factory AnswerResponse.fromJson(Map<String, dynamic> json) => AnswerResponse(
        answers: List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
    };
}

class Answer {
    String? questionId;
    String? answer;

    Answer({
         this.questionId,
         this.answer,
    });

    factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        questionId: json["question_id"],
        answer: json["answer"],
    );

    Map<String, dynamic> toJson() => {
        "question_id": questionId,
        "answer": answer,
    };
}
