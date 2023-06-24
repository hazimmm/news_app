import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdatePasswordScreen extends StatefulWidget {
  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String _newPassword = '';
  String _error = '';

  void _updatePassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.currentUser!.updatePassword(_newPassword);
        Navigator.pop(context); // Return to the previous screen
      } catch (e) {
        setState(() {
          _error = 'Failed to update password. Please try again.';
        });
      }
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Password'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'New Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a new password';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _newPassword = value.trim();
                  });
                },
              ),
              SizedBox(height: 16.0),

              Center(
                child: ElevatedButton(
                  onPressed: _updatePassword,
                  child: Text('Update Password'),
                  style: ElevatedButton.styleFrom(
                        primary: Colors.purple, 
                      ),
                ),
              ),
              if (_error.isNotEmpty)
                Text(
                  _error,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
