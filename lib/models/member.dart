class Member {
  String id;
  String name;
  String email;
  DateTime timestamp;

  Member({
    required this.id,
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
