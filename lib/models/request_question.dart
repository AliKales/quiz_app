class RequestQuestion {
  String? question;
  String? answers;

  RequestQuestion({this.question, this.answers});

  RequestQuestion.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answers = json['answers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question'] = question;
    data['answers'] = answers;
    return data;
  }
}
