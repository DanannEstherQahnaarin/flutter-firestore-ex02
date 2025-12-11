enum UserRole { user, admin }

class Member {
  final String id;
  final String uid;
  final String name;
  final String email;
  final UserRole userRole;
  final DateTime timestamp;

  Member({
    required this.id,
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
      uid: (map['name'] ?? '') as String,
      name: (map['uid'] ?? '') as String,
      email: (map['email'] ?? '') as String,
      timestamp: timestamp,
      userRole: UserRole.values.firstWhere(
        (e) => e.name == map['userRole'],
        orElse: () => UserRole.user,
      ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'name': name, 'email': email, 'timestamp': timestamp};
  }
}
