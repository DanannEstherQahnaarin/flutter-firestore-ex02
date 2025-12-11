class Member {
  final String id;
  final String uid;
  final String name;
  final String email;

  final DateTime timestamp;

  Member({
    required this.id,
    this.uid = '',
    required this.name,
    required this.email,
    required this.timestamp,
  });

  factory Member.fromFirestore(Map<String, dynamic> map, String id) {
    final timestamp = map['timestamp'] != null
        ? map['timestamp'].toDate()
        : DateTime.now();

    return Member(
      id: id,
      name: (map['name'] ?? '') as String,
      email: (map['email'] ?? '') as String,
      timestamp: timestamp,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'name': name, 'email': email, 'timestamp': timestamp};
  }
}
