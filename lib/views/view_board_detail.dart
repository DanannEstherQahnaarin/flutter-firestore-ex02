import 'package:flutter/material.dart';
import 'package:flutter_application_mms/models/board.dart';
import 'package:flutter_application_mms/models/member.dart';

class DetailBoardPage extends StatefulWidget {
  final Board board;
  final Member member;

  const DetailBoardPage({super.key, required this.board, required this.member});

  @override
  State<DetailBoardPage> createState() => _DetailBoardPageState();
}

class _DetailBoardPageState extends State<DetailBoardPage> {
  late TextEditingController _txtTitleController;
  late TextEditingController _txtContentController;
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
