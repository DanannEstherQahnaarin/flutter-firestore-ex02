enum UserRole { user, admin }

/// UserRole enum에 대한 확장 메서드
extension UserRoleExtension on UserRole {
  /// UserRole enum 값을 한글 표시명으로 변환
  /// - UserRole.user -> '사용자'
  /// - UserRole.admin -> '관리자'
  String get displayName {
    switch (this) {
      case UserRole.user:
        return '사용자';
      case UserRole.admin:
        return '관리자';
    }
  }
}

class Member {
  final String? id;
  final String? uid;
  final String name;
  final String email;
  final UserRole userRole;
  final DateTime timestamp;

  Member({
    this.id,
    required this.uid,
    required this.name,
    required this.email,
    required this.userRole,
    required this.timestamp,
  });

  factory Member.fromFirestore(Map<String, dynamic> map, String id) {
    final timestamp = map['timestamp'] != null
        ? map['timestamp'].toDate()
        : DateTime.now();

    return Member(
      id: id,
      uid: (map['uid'] ?? '') as String,
      name: (map['name'] ?? '') as String,
      email: (map['email'] ?? '') as String,
      timestamp: timestamp,
      userRole: UserRole.values.firstWhere(
        (e) => e.name == map['userRole'],
        orElse: () => UserRole.user,
      ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'uid' : uid,
      'userRole': userRole.name,
      'timestamp': timestamp,
    };
  }
}
