class Major {
  final int id; 
  final String department;
  final String major;
  final bool receiveNotification;

  Major({
    required this.id, 
    required this.department,
    required this.major,
    this.receiveNotification = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Major &&
          runtimeType == other.runtimeType &&
          // department == other.department &&
          // major == other.major;
          id == other.id; 

  @override
  // int get hashCode => department.hashCode ^ major.hashCode;
  int get hashCode => id.hashCode; 

  Major copyWith({
    String? department,
    String? major,
    bool? receiveNotification,
  }) {
    return Major(
      id: id ?? this.id, 
      department: department ?? this.department,
      major: major ?? this.major,
      receiveNotification: receiveNotification ?? this.receiveNotification,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 
    'department': department,
    'major': major,
    'receiveNotification': receiveNotification,
  };

  factory Major.fromJson(Map<String, dynamic> json) {
    return Major(
      id: json['id'] ?? -1, 
      department: json['department'] ?? '',
      major: json['major'] ?? '',
      receiveNotification: json['receiveNotification'] ?? false,
    );
  }
}
