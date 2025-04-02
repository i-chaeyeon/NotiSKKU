class Major {
  final String department;
  final String major;
  final bool receiveNotification;

  Major({
    required this.department,
    required this.major,
    this.receiveNotification = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Major &&
          runtimeType == other.runtimeType &&
          department == other.department &&
          major == other.major;

  @override
  int get hashCode => department.hashCode ^ major.hashCode;

  Major copyWith({
    String? department,
    String? major,
    bool? receiveNotification,
  }) {
    return Major(
      department: department ?? this.department,
      major: major ?? this.major,
      receiveNotification: receiveNotification ?? this.receiveNotification,
    );
  }

  Map<String, dynamic> toJson() => {
    'department': department,
    'major': major,
    'receiveNotification': receiveNotification,
  };

  factory Major.fromJson(Map<String, dynamic> json) {
    return Major(
      department: json['department'] ?? '',
      major: json['major'] ?? '',
      receiveNotification: json['receiveNotification'] ?? false,
    );
  }
}
