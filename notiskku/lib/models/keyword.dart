enum Defined { user, developer }

class Keyword {
  final String keyword;
  final Defined defined;
  final bool receiveNotification;

  Keyword({
    required this.keyword,
    required this.defined,
    this.receiveNotification = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Keyword &&
          runtimeType == other.runtimeType &&
          keyword == other.keyword &&
          defined == other.defined;

  @override
  int get hashCode => keyword.hashCode ^ defined.hashCode;

  Keyword copyWith({
    String? keyword,
    Defined? defined,
    bool? receiveNotification,
  }) {
    return Keyword(
      keyword: keyword ?? this.keyword,
      defined: defined ?? this.defined,
      receiveNotification: receiveNotification ?? this.receiveNotification,
    );
  }

  Map<String, dynamic> toJson() => {
    'keyword': keyword,
    'defined': defined.name,
    'receiveNotification': receiveNotification,
  };

  factory Keyword.fromJson(Map<String, dynamic> json) {
    return Keyword(
      keyword: json['keyword'] ?? '',
      defined: Defined.values.byName(json['defined'] ?? 'user'),
      receiveNotification: json['receiveNotification'] ?? false,
    );
  }
}
