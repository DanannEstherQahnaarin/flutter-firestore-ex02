import 'package:flutter/material.dart';
import 'package:flutter_application_mms/common_widget/appbars.dart';
import 'package:flutter_application_mms/common_widget/textformfields.dart';
import 'package:flutter_application_mms/service/service_board.dart';
import 'package:flutter_application_mms/service/service_validation.dart';

class AddBordPage extends StatefulWidget {
  const AddBordPage({super.key});

  @override
  State<AddBordPage> createState() => _AddBordPageState();
}

class _AddBordPageState extends State<AddBordPage> {
  final formKey = GlobalKey<FormState>();
  final BoardService boardService = BoardService();
  final TextEditingController _txtTitleController = TextEditingController();
  final TextEditingController _txtContentController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: MyAppBar(title: '글쓰기'),
    body: Padding(
      padding: const EdgeInsets.all(10),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            CustomInputFormField(
              controller: _txtTitleController,
              labelText: 'Title',
              validator: (value) =>
                  ValidationService.validateRequired(value: value ?? '', fieldName: '제목'),
            ),
            Expanded(
              child: CustomInputFormField(
                controller: _txtContentController,
                labelText: '내용',
                expands: true,
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                final String title = _txtTitleController.text;
                final String content = _txtContentController.text;

                boardService.submitBoard(title: title, content: content).then((issubmit) {
                  if(context.mounted == false) return;

                  if (issubmit) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('등록되었습니다.')),
                    );
                    Navigator.pop(context); // 성공 시 이전 화면으로 이동
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('등록에 실패했습니다. 다시 시도해주세요.')),
                    );
                  }
                });
              },
              child: const Text('등록'),
            ),
          ],
        ),
      ),
    ),
  );
}
