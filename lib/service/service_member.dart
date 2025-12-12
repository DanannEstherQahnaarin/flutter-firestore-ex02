import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_mms/models/member.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;
final String _collection = 'mms';

enum Answer { success, fail }

Stream<List<Member>> getMemberStream() {
  return _db
      .collection(_collection)
      .orderBy('timestamp')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => Member.fromFirestore(doc.data(), doc.id))
            .toList(),
      );
}

Future<String> addMemberToFirebase({
  required String name,
  required String email,
  required UserRole userRole,
}) async {
  final addMember = Member(
    name: name,
    email: email,
    userRole: userRole,
    timestamp: DateTime.now(),
  );

  try {
    await _db.collection(_collection).add(addMember.toFirestore());

    return Answer.success.name;
  } catch (e) {
    return Answer.fail.name;
  }
}
