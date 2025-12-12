import 'package:flutter/material.dart';
import 'package:flutter_application_mms/models/member.dart';
import 'package:flutter_application_mms/service/service_member.dart';

extension MenuOptionExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.user:
        return '사용자';
      case UserRole.admin:
        return '관리자';
    }
  }
}

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({super.key});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final TextEditingController _txtNameController = TextEditingController();
  final TextEditingController _txtEmailController = TextEditingController();
  UserRole _selectedRole = UserRole.user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Member Add'),
      content: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: ListBody(
          children: [
            TextField(
              controller: _txtNameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(hintText: 'Name'),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _txtEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(hintText: 'Email'),
            ),
            SizedBox(height: 15),
            DropdownMenu(
              initialSelection: UserRole.user,
              dropdownMenuEntries: UserRole.values
                  .map<DropdownMenuEntry<UserRole>>((UserRole option) {
                    return DropdownMenuEntry<UserRole>(
                      value: option,
                      // label: 드롭다운 메뉴와 선택 창에 표시될 텍스트
                      label: option.displayName,
                      leadingIcon: option == UserRole.admin
                          ? Icon(Icons.person_2)
                          : Icon(Icons.person),
                    );
                  })
                  .toList(),
              onSelected: (value) {
                if (value != null) {
                  setState(() {
                    _selectedRole = value;
                  });
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _addMember(
                  context: context,
                  name: _txtNameController.text,
                  email: _txtEmailController.text,
                  role: _selectedRole,
                );
              },
              child: Text('Add Member'),
            ),
          ],
        ),
      ),
    );
  }
}

void _addMember({
  required String name,
  required String email,
  required UserRole role,
  required BuildContext context,
}) async {
  if (name.isEmpty) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Name is Empty')));
    return;
  }

  if (email.isEmpty) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Email is Empty')));
    return;
  }

  String result = await addMemberToFirebase(
    name: name,
    email: email,
    userRole: role,
  );

  if (!context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        result == 'success'
            ? 'Member added successfully'
            : 'Failed to add member',
      ),
    ),
  );

  // 성공 시 다이얼로그 닫기
  if (result == 'success') {
    Navigator.of(context).pop();
  }
}
