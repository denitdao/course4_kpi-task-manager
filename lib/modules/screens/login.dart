import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text("Login Page"),
        ),
        body: Center(
          child: Column(
            children: [
              TextFormField(
                initialValue: 'Input text',
                decoration: const InputDecoration(
                  labelText: 'Label text',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple)
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  primary: Colors.deepPurpleAccent,
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/today');
                },
                child: const Text("Login"),
              ),
            ],
          ),
        ));
  }
}
// () => {Navigator.pushReplacementNamed(context, '/today')}