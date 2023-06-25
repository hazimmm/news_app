import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:news/reusable_widgets/reusable_widgets.dart';
import 'package:news/utils/color_utils.dart';
import 'dart:io';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  File? _profileImage;

  bool _isLoading = false; // Add a new boolean variable to track loading state

  Future<void> createUserWithEmailAndPassword(
      String email, String password, String username) async {
    if (_profileImage == null ||
        username.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Incomplete Details'),
            content: Text('Please enter all details including the profile picture.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      _isLoading = true; // Set loading state to true when starting the account creation process
    });
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Store user data in Firestore
      String uid = userCredential.user!.uid;
      Map<String, dynamic> userData = {
        'username': username,
        'email': email,
        'password': password,
      };

      // Upload the profile image
      String profileImageUrl = await uploadProfileImage(uid, _profileImage!);
      userData['profileImageUrl'] = profileImageUrl;

      // Save the data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(userData);

      print("New Account Created");
      Navigator.pushReplacementNamed(context, '/home');
    } catch (error) {
      print("Error: $error");
    } finally {
      setState(() {
        _isLoading = false; // Set loading state to false when account creation process is finished
      });
    }
  }

  Future<String> uploadProfileImage(String userId, File imageFile) async {
    String fileName = 'profile_$userId.jpg';
    Reference storageReference =
        FirebaseStorage.instance.ref().child('profile_images/$fileName');
    UploadTask uploadTask = storageReference.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("CB2B93"),
              hexStringToColor("9546C4"),
              hexStringToColor("5E61F4")
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
                      child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                        child: _profileImage == null
                            ? Icon(Icons.person, size: 60, color: Colors.purple)
                            : null,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          final pickedImage = await ImagePicker().getImage(
                            source: ImageSource.gallery,
                          );
                          if (pickedImage != null) {
                            setState(() {
                              _profileImage = File(pickedImage.path);
                            });
                          }
                        },
                        child: Text('Upload Profile Image'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.purple,
                        ),
                      ),
                      const SizedBox(height: 20),
                      reusableTextField(
                        "Enter Username",
                        Icons.person_outline,
                        false,
                        _userNameTextController,
                      ),
                      const SizedBox(height: 20),
                      reusableTextField(
                        "Enter Email Address",
                        Icons.email_outlined,
                        false,
                        _emailTextController,
                      ),
                      const SizedBox(height: 20),
                      reusableTextField(
                        "Enter Password",
                        Icons.lock_outlined,
                        true,
                        _passwordTextController,
                      ),
                      const SizedBox(height: 20),
                      _isLoading // Show CircularProgressIndicator when loading state is true
                          ? CircularProgressIndicator()
                          : firebaseUIButton(context, "Sign Up", () {
                              String username = _userNameTextController.text.trim();
                              String email = _emailTextController.text.trim();
                              String password = _passwordTextController.text;

                              createUserWithEmailAndPassword(email, password, username);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension FirestoreExtension on Map<String, dynamic> {
  Map<String, dynamic> toJson() {
    return this; // No need to convert, since Firestore accepts `Map<String, dynamic>` directly
  }
}
