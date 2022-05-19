class QuestionReport {
  String? question;
  String? answers;
  String? report;

  QuestionReport({this.question, this.answers, this.report});

  QuestionReport.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answers = json['answers'];
    report = json['report'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question'] = question;
    data['answers'] = answers;
    data['report'] = report;
    return data;
  }
}
