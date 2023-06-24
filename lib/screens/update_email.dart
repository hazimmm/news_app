import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateEmailScreen extends StatefulWidget {
  @override
  _UpdateEmailScreenState createState() => _UpdateEmailScreenState();
}

class _UpdateEmailScreenState extends State<UpdateEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String _newEmail = '';
  String _error = '';

  void _updateEmail() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.currentUser!.updateEmail(_newEmail);
        Navigator.pop(context); // Return to the previous screen
      } catch (e) {
        setState(() {
          _error = 'Failed to update email. Please try again.';
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Email'),
        backgroundColor: Colors.purple,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'New Email',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a new email';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _newEmail = value.trim();
                    });
                  },
                ),

                SizedBox(height: 16.0),

                Center(
                  child:ElevatedButton(
                    onPressed: _updateEmail,
                    child: Text('Update Email'),
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
      ),
    );
  }
}
