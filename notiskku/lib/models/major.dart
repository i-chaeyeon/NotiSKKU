class Major {
  final String department;
  final String major;
  final bool receiveNotification;

  Major({
    required this.department,
    required this.major,
    this.receiveNotification = false,
  });

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
