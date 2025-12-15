import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionModel {
  String? id;
  String question;
  String? description;
  String? imageUrl;
  List<String> options;
  int correctAnswerIndex;
  String explanation;
  int order;
  bool isSynced;

  QuestionModel({
    this.id,
    required this.question,
    this.description,
    this.imageUrl,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation = '',
    required this.order,
    this.isSynced = true,
  });

  Map<String, dynamic> toJson() => {
    "question": question,
    "description": description,
    "imageUrl": imageUrl,
    "options": options,
    "correctAnswerIndex": correctAnswerIndex,
    "explanation": explanation,
    "order": order,
  };

  factory QuestionModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return QuestionModel(
      id: doc.id,
      question: data['question'] ?? data['questionText'] ?? '',
      description: data['description'],
      imageUrl: data['imageUrl'],
      options: List<String>.from(data['options'] ?? []),
      correctAnswerIndex: data['correctAnswerIndex'] ?? 0,
      explanation: data['explanation'] ?? '',
      order: data['order'] ?? 0,
      isSynced: !doc.metadata.hasPendingWrites,
    );
  }
}
