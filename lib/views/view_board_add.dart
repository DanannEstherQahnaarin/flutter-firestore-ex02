import 'package:flutter/material.dart';
import 'package:flutter_application_mms/common_widget/appbars.dart';
import 'package:flutter_application_mms/common_widget/textformfields.dart';
import 'package:flutter_application_mms/service/service_validation.dart';

class AddBordPage extends StatefulWidget {
  const AddBordPage({super.key});

  @override
  State<AddBordPage> createState() => _AddBordPageState();
}

class _AddBordPageState extends State<AddBordPage> {
  final TextEditingController _txtTitleController = TextEditingController();
  final TextEditingController _txtContentController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: MyAppBar(title: '글쓰기'),
    body: Padding(
      padding: const EdgeInsets.all(10),
      child: Form(
        child: Column(
          children: [
            CustomInputFormField(
              controller: _txtTitleController,
              labelText: 'Title',
              validator: (value) =>
                  ValidationService.validateRequired(value: value ?? '', fieldName: '제목'),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  CustomInputFormField(
                    controller: _txtContentController,
                    labelText: 'Content',
                    expands: true,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
