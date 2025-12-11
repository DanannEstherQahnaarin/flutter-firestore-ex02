import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_mms/models/member.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;
final String _collection = 'mms';

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
