import 'package:flutter/material.dart';
import 'package:flutter_application_mms/models/member.dart';
import 'package:flutter_application_mms/service/service_member.dart';

class UpdateUserDialog extends StatefulWidget {
  final Member updateMember;

  const UpdateUserDialog({required this.updateMember, super.key});

  @override
  State<UpdateUserDialog> createState() => _UpdateUserDialog();
}

class _UpdateUserDialog extends State<UpdateUserDialog> {
  late final TextEditingController txtNameController;
  late final TextEditingController txtEmailController;

  @override
  void initState() {
    super.initState();
    txtNameController = TextEditingController(text: widget.updateMember.name);
    txtEmailController = TextEditingController(text: widget.updateMember.email);
    selectedRole = widget.updateMember.userRole;
  }

  UserRole selectedRole = UserRole.user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Member Update'),
      content: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: ListBody(
          children: [
            TextField(
              controller: txtNameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(hintText: 'Name'),
            ),
            SizedBox(height: 15),
            TextField(
              controller: txtEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(hintText: 'Email'),
            ),
            SizedBox(height: 15),
            DropdownMenu(
              initialSelection: widget.updateMember.userRole,
              dropdownMenuEntries: UserRole.values
                  .map<DropdownMenuEntry<UserRole>>((UserRole option) {
                    return DropdownMenuEntry<UserRole>(
                      // 실제 선택될 enum 값
                      value: option,
                      // 드롭다운 메뉴와 선택 창에 표시될 한글 텍스트
                      label: option.displayName,
                      // 역할에 따라 다른 아이콘 표시
                      // admin: verified_user 아이콘, user: person 아이콘
                      leadingIcon: option == UserRole.admin
                          ? Icon(Icons.verified_user)
                          : Icon(Icons.person),
                    );
                  })
                  .toList(),

              // 드롭다운에서 항목 선택 시 호출되는 콜백
              onSelected: (value) {
                if (value != null) {
                  // 선택된 역할을 State에 저장하고 UI 업데이트
                  setState(() {
                    selectedRole = value;
                  });
                  print(selectedRole);
                }
              },
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                print(selectedRole);
                _updateMember(
                  member: Member(
                    id: widget.updateMember.id,
                    uid: widget.updateMember.uid,
                    name: txtNameController.text,
                    email: txtEmailController.text,
                    userRole: selectedRole,
                    timestamp: widget.updateMember.timestamp,
                  ),
                  context: context,
                );
              },
              child: Text('Update Member'),
            ),
          ],
        ),
      ),
    );
  }
}

void _updateMember({
  required Member member,
  required BuildContext context,
}) async {
  if (member.name.isEmpty) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Name is Empty')));
    return;
  }

  if (member.email.isEmpty) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Email is Empty')));
    return;
  }

  String result = await updateMemberToFirebase(member: member);

  if (!context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        result == Answer.success.name
            ? 'Member update successfully'
            : 'Failed to update member',
      ),
    ),
  );

  if (result == Answer.success.name) {
    Navigator.of(context).pop();
  }
}
