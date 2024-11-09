
class AnswerResponse {
    List<Answer> answers;
    String quizId;

    AnswerResponse({
        required this.answers,
        required this.quizId
    });

    factory AnswerResponse.fromJson(Map<String, dynamic> json) => AnswerResponse(
        answers: List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
        quizId: json['quiz_id']
    );

    Map<String, dynamic> toJson() => {
        "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
        "quiz_id":quizId
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
