import 'package:flutter/material.dart';
import 'package:flutter_application_mms/service/service_member.dart';

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({super.key});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final TextEditingController _txtNameController = TextEditingController();
  final TextEditingController _txtEmailController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return AlertDialog();
  }
}


  void _addMember({required String name, required String email, required BuildContext context}) async {
  // final String name = _txtNameController.text;
  // final String email = _txtEmailController.text;

  if(name.isEmpty){
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Name is Empty'))
    );
    return;
  }

  if(email.isEmpty){
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email is Empty'))
    );
    return;
  }

  String result = await addMemberToFirebase(name: name, email: email);
  
  if (!context.mounted) return;
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(result == 'success' ? 'Member added successfully' : 'Failed to add member'))
  );
  
  // 성공 시 다이얼로그 닫기
  if (result == 'success') {
    Navigator.of(context).pop();
  }
}