// lib/models/knowledge_model.dart
import 'dart:convert';

class KnowledgeCategory {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final List<KnowledgeArticle> articles;

  KnowledgeCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    this.articles = const [],
  });

  KnowledgeCategory copyWith({
    String? id,
    String? title,
    String? description,
    String? iconName,
    List<KnowledgeArticle>? articles,
  }) {
    return KnowledgeCategory(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      articles: articles ?? this.articles,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconName': iconName,
      'articles': articles.map((article) => article.toJson()).toList(),
    };
  }

  factory KnowledgeCategory.fromJson(Map<String, dynamic> json) {
    return KnowledgeCategory(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      iconName: json['iconName'],
      articles: json['articles'] != null
          ? List<KnowledgeArticle>.from(
              json['articles'].map((x) => KnowledgeArticle.fromJson(x)))
          : [],
    );
  }
}

class KnowledgeArticle {
  final String id;
  final String title;
  final String content;
  final String author;
  final DateTime publishDate;
  final List<String> tags;

  KnowledgeArticle({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.publishDate,
    this.tags = const [],
  });

  KnowledgeArticle copyWith({
    String? id,
    String? title,
    String? content,
    String? author,
    DateTime? publishDate,
    List<String>? tags,
  }) {
    return KnowledgeArticle(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      author: author ?? this.author,
      publishDate: publishDate ?? this.publishDate,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author': author,
      'publishDate': publishDate.toIso8601String(),
      'tags': tags,
    };
  }

  factory KnowledgeArticle.fromJson(Map<String, dynamic> json) {
    return KnowledgeArticle(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      author: json['author'],
      publishDate: DateTime.parse(json['publishDate']),
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
    );
  }
}
