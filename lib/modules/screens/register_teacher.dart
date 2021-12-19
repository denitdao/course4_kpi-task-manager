import 'package:flutter/material.dart';

class RegisterTeacherPage extends StatelessWidget {
  const RegisterTeacherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(),
    );
  }
}
