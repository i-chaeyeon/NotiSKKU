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
