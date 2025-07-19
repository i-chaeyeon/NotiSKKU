enum Defined { user, developer }

class Keyword {
  final int id;
  final String keyword;
  final Defined defined;
  final bool receiveNotification;

  Keyword({
    required this.id,
    required this.keyword,
    required this.defined,
    this.receiveNotification = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Keyword &&
          runtimeType == other.runtimeType &&
          // keyword == other.keyword &&
          // defined == other.defined;
          id == other.id;

  @override
  // int get hashCode => keyword.hashCode ^ defined.hashCode;
  int get hashCode => id.hashCode;

  Keyword copyWith({
    int? id,
    String? keyword,
    Defined? defined,
    bool? receiveNotification,
  }) {
    return Keyword(
      id: id ?? this.id,
      keyword: keyword ?? this.keyword,
      defined: defined ?? this.defined,
      receiveNotification: receiveNotification ?? this.receiveNotification,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'keyword': keyword,
    'defined': defined.name,
    'receiveNotification': receiveNotification,
  };

  factory Keyword.fromJson(Map<String, dynamic> json) {
    return Keyword(
      id: json['id'] ?? -1,
      keyword: json['keyword'] ?? '',
      defined: Defined.values.byName(json['defined'] ?? 'user'),
      receiveNotification: json['receiveNotification'] ?? false,
    );
  }
}
