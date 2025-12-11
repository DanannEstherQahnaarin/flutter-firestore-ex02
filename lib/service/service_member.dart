import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_mms/models/member.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;
final String _collection = 'mms';

enum answer { success, fail }

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

Future<String> addMemberToFirebase({required String name, required String email}) async {
  final addMember = Member(
    name: name,
    email: email,
    userRole: UserRole.user,
    timestamp: DateTime.now(),
  );

  try {
    await _db.collection(_collection).add(addMember.toFirestore());

    return answer.success.name;
  } catch (e) {
    return answer.fail.name;
  }
}
