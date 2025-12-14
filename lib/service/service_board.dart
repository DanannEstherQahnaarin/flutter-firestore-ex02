import 'package:flutter_application_mms/models/board.dart';
import 'package:flutter_application_mms/models/member.dart';
import 'package:flutter_application_mms/service/service_auth.dart';

class BoardService {
  void submitBoard({
    required Member member,
    required String title,
    required String content,
  }) async {
    final newBoard = Board(
      title: title,
      content: content,
      writerUid: member.uid ?? '',
      writerNm: member.name,
      timestamp: DateTime.now(),
    );

    try {
      await AuthService().addBoard(newBoard);
    } on Exception catch (e) {
      print(e);
    }
  }
}
