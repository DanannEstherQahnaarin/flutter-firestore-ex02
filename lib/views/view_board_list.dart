import 'package:flutter/material.dart';
import 'package:flutter_application_mms/common_widget/appbars.dart';
import 'package:flutter_application_mms/service/service_auth.dart';
import 'package:flutter_application_mms/views/view_board_add.dart';

class BoardPage extends StatelessWidget {
  const BoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserEmail = AuthService().firebaseAuth.currentUser?.email ?? 'Unknown User';
    return Scaffold(
      appBar: MyAppBar(title: 'Board'),
      body: Column(
        children: [
          const Divider(),
          Expanded(child: Column(
            children: [],
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed:() {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddBordPage(),));
      },
      child: Icon(Icons.edit),),
    );
  }
}