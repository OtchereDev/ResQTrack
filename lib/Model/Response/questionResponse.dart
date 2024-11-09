class QuestionResponse {
  int? status;
  Data? data;

  QuestionResponse({this.status, this.data});

  QuestionResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Quiz? quiz;

  Data({this.quiz});

  Data.fromJson(Map<String, dynamic> json) {
    quiz = json['quiz'] != null ? Quiz.fromJson(json['quiz']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (quiz != null) {
      data['quiz'] = quiz!.toJson();
    }
    return data;
  }
}

class Quiz {
  String? sId;
  String? title;
  String? description;
  List<Questions>? questions;
  String? image;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Quiz(
      {this.sId,
      this.title,
      this.description,
      this.questions,
      this.image,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Quiz.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(Questions.fromJson(v));
      });
    }
    image = json['image'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['title'] = title;
    data['description'] = description;
    if (questions != null) {
      data['questions'] = questions!.map((v) => v.toJson()).toList();
    }
    data['image'] = image;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Questions {
  String? question;
  List<Options>? options;
  String? correctAnswer;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int?  selectedOption = -1;


  Questions(
      {this.question,
      this.options,
      this.correctAnswer,
      this.sId,
      this.selectedOption,

      this.createdAt,
      this.updatedAt});

  Questions.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
    correctAnswer = json['correctAnswer'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    selectedOption = json['selectedOption'];

    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['question'] = question;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    data['correctAnswer'] = correctAnswer;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['selectedOption'] = selectedOption;

    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Options {
  String? answer;
  String? symbol;
  String? sId;
  String? createdAt;
  String? updatedAt;

  Options({this.answer, this.symbol, this.sId, this.createdAt, this.updatedAt});

  Options.fromJson(Map<String, dynamic> json) {
    answer = json['answer'];
    symbol = json['symbol'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['answer'] = answer;
    data['symbol'] = symbol;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
