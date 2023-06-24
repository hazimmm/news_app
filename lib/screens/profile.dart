import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:news/screens/update_email.dart'; //update email page
import 'package:news/screens/update_password.dart'; //update password page



class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User _user;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _userStream;

  File? _Image;
  ImageProvider? _profileImage;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _userStream = _firestore.collection('users').doc(_user.uid).snapshots();
  }

  //Edit profile picture
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    
    setState(() {
      if (pickedImage != null) {
          _Image = File(pickedImage.path);
          _profileImage = FileImage(_Image!);
        }
      });
  }

  // Retrieve user's profile data from Firebase
  Future<User> getUserData() async {
    User user = _auth.currentUser as User;
    return user;
  }

  // Update user's email
  Future<void> updateEmail(String newEmail) async {
    User user = _auth.currentUser as User;
    await user.updateEmail(newEmail);
  }

  // Update user's password
  Future<void> updatePassword(String newPassword) async {
    User user = _auth.currentUser as User;
    await user.updatePassword(newPassword);
  }

  // Delete user's account
  Future<void> deleteAccount() async {
    User user = _auth.currentUser!;
    await user.delete();
    Navigator.pushReplacementNamed(context, '/login'); // Navigate to login page
  }

  // Logout the user
  Future<void> logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login'); // Navigate to login page
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: Colors.purple,
      ),

      body: FutureBuilder(
        future: getUserData(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {

              User? user = snapshot.data;

              return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: _userStream,
                builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting){
                              return Center(child: CircularProgressIndicator());
                            } else {
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                final userData = snapshot.data!.data();
                                final String username = userData?['username']?? '';

                                return Center(
                                  child: Column(
                                    children: [

                                      SizedBox(height: 70),

                                      _Image != null ? CircleAvatar(radius:80, backgroundImage: _profileImage) //Image.file(_image!)->putting this, there'll be no circular frame
                                                      : CircleAvatar(
                                                          radius: 80,
                                                          backgroundColor: Colors.grey,
                                                          backgroundImage: _profileImage != null
                                                            ? FileImage(_profileImage! as File)
                                                            : AssetImage('assets/images/profile.png') as ImageProvider<Object>?,
                                                        ),

                                      SizedBox(height:10),

                                      //6. Add a button for user to upload a profile picture
                                      ElevatedButton( onPressed: _pickImage, 
                                                      child: Text('Upload Profile Picture'),
                                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, 
                                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
                                                                                      minimumSize: Size(10, 45),
                                                                                      ),  
                                                    ),


                                      SizedBox(height:30),

                                      Text('Username: ${user?.displayName}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                      
                                      ),

                                      SizedBox(height: 10),

                                      Text('Email: ${user?.email}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                      ),

                                      SizedBox(height: 30),

                                      Container(
                                        width:150,
                                        child:  ElevatedButton(
                                            onPressed: () {
                                              // Navigate to a screen to update email
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => UpdateEmailScreen()),
                                              );
                                            },
                                            child: Text('Update Email'),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.purple, 
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
                                            ),
                                          ),
                                      ),

                                      Container(  
                                        width:150,
                                        child:  ElevatedButton(
                                            onPressed: () {
                                              // Navigate to a screen to update password
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => UpdatePasswordScreen()),
                                              );
                                            },
                                            child: Text('Update Password'),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.purple, 
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
                                            ),
                                          ),
                                      ),

                                      Container(
                                        width: 150,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Delete Account'),
                                                  content: Text('Are you sure you want to delete your account?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      child: Text('Delete'),
                                                      onPressed: deleteAccount,
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text('Delete Account'),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.purple,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 30),

                                      Container(
                                        width: 100,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Logout'),
                                                  content: Text('You have to sign-in once logged out. Are you sure you want to logout?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      child: Text('Logout'),
                                                      onPressed: deleteAccount,
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text('Logout'),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.purple,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
                                          ),
                                        )
                                      )
                                    ],
                                  )
                                );
                              }
                              }
                            }
              );
              
            }
          }
        },
      ),
    );
  }
}



