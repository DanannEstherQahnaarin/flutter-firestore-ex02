import 'package:flutter/material.dart';
import 'package:flutter_application_mms/common_widget/appbars.dart';
import 'package:flutter_application_mms/common_widget/textformfields.dart';
import 'package:flutter_application_mms/dialog/dialogs.dart';
import 'package:flutter_application_mms/models/board.dart';
import 'package:flutter_application_mms/service/service_validation.dart';

class DetailBoardPage extends StatefulWidget {
  final Board board;

  const DetailBoardPage({super.key, required this.board});

  @override
  State<DetailBoardPage> createState() => _DetailBoardPageState();
}

class _DetailBoardPageState extends State<DetailBoardPage> {
  late TextEditingController _txtTitleController;
  late TextEditingController _txtContentController;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _txtTitleController = TextEditingController(text: widget.board.title);
    _txtContentController = TextEditingController(text: widget.board.content);
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: MyAppBar(title: isEditing ? '게시글 수정' : '게시글 상세'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              if (isEditing)
                CustomInputFormField(
                  controller: _txtTitleController,
                  labelText: 'Title',
                  validator: (value) =>
                      ValidationService.validateRequired(value: value ?? '', fieldName: '제목'),
                )
              else
                Text(
                  widget.board.title,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                ),
              const Divider(),
              Text(
                '작성자 : ${widget.board.writerNm} | 작성일 : ${widget.board.timestamp}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: isEditing
                      ? CustomInputFormField(
                          controller: _txtContentController,
                          labelText: '내용',
                          maxLines:
                              null, // null maxLines + expands can cause "The following RenderObject was being processed when the exception was fired"
                          keyboardType: TextInputType.multiline,
                        )
                      : Text(
                          widget.board.content,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                ),
              ),
              const SizedBox(height: 20),
              if (isEditing)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        final updateBoard = Board(
                          id: widget.board.id,
                          title: _txtTitleController.text,
                          content: _txtContentController.text,
                          writerUid: widget.board.writerUid,
                          writerNm: widget.board.writerNm,
                          timestamp: DateTime.now(),
                        );

                        showUpdateBoardDialog(board: updateBoard, context: context);
                        Navigator.of(
                          context,
                        ).pushNamedAndRemoveUntil('/board_list', (route) => false);
                      },
                      child: const Text('저장'),
                    ),
                    const SizedBox(width: 20),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        showDeleteBoardDialog(board: widget.board, context: context);
                      },
                      child: const Text('삭제'),
                    ),
                    const SizedBox(width: 20),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        setState(() {
                          isEditing = false;
                          _txtTitleController.text = widget.board.title;
                          _txtContentController.text = widget.board.content;
                        });
                      },
                      child: const Text('취소'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: !isEditing
          ? FloatingActionButton.extended(
              onPressed: () {
                if (!isEditing) {
                  setState(() {
                    isEditing = true;
                  });
                } else {
                  setState(() {
                    isEditing = false;
                    _txtTitleController.text = widget.board.title;
                    _txtContentController.text = widget.board.content;
                  });
                }
              },
              label: const Text('수정'),
              icon: const Icon(Icons.edit),
              backgroundColor: Colors.blue,
            )
          : null,
    );
  }
}
