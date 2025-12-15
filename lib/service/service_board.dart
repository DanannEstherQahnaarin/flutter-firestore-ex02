import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_mms/models/board.dart';
import 'package:flutter_application_mms/models/member.dart';
import 'package:flutter_application_mms/service/service_auth.dart';

class BoardService {
  Future<bool> submitBoard({required String title, required String content}) async {
    final User? user = AuthService().firebaseAuth.currentUser;
    if (user == null) {
      debugPrint('No user is currently signed in');
      return false;
    }
    final Member? member = await AuthService().getUserModelByUid(user);
    if (member == null) {
      debugPrint('Member not found for current user');
      return false;
    }

    final newBoard = Board(
      title: title,
      content: content,
      writerUid: member.uid,
      writerNm: member.name,
      timestamp: DateTime.now(),
    );

    try {
      await AuthService().addBoard(newBoard);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
