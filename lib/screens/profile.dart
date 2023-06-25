import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  late User _user;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _userStream;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _userStream = _firestore.collection('users').doc(_user.uid).snapshots();
  }

  Future<void> _updateEmail(String newEmail) async {
    try {
      await _user.updateEmail(newEmail);
      await _firestore
          .collection('users')
          .doc(_user.uid)
          .update({'email': newEmail});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email updated successfully.')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update email. Please try again.')),
      );
    }
  }

  Future<void> _updatePassword(String newPassword) async {
    try {
      await _user.updatePassword(newPassword);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password updated successfully.')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update password. Please try again.')),
      );
    }
  }

  Future<void> _updateUsername(String newUsername) async {
    try {
      await _firestore
          .collection('users')
          .doc(_user.uid)
          .update({'username': newUsername});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username updated successfully.')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update username. Please try again.')),
      );
    }
  }

  Future<void> _deleteAccount() async {
    try {
      await _user.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account deleted successfully.')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account. Please try again.')),
      );
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to logout. Please try again.')),
      );
    }
  }

  Future<String> uploadProfileImage(String userId, File imageFile) async {
    try {
      String fileName = 'profile_$userId.jpg';
      Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_images/$fileName');
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> _updateProfilePicture() async {
    try {
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
        String profileImageUrl =
            await uploadProfileImage(_user.uid, _profileImage!);
        await _firestore
            .collection('users')
            .doc(_user.uid)
            .update({'profileImageUrl': profileImageUrl});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile picture updated successfully.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile picture. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: Colors.purple,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _userStream,
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return Text('User data not found');
            } else {
              final userData = snapshot.data!.data();
              final String username = userData!['username'];
              final String email = userData['email'];
              final String profileImageUrl = userData['profileImageUrl'];

              Widget profileImageWidget;
              if (profileImageUrl != null && profileImageUrl.isNotEmpty) {
                profileImageWidget = CircleAvatar(
                  radius: 50,
                  child: ClipOval(
                    child: Image.network(
                      profileImageUrl,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  ),
                );
              } else {
                profileImageWidget = CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: Colors.purple),
                );
              }
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 70.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
GestureDetector(
  onTap: _updateProfilePicture,
  child: Center(
    child: Stack(
      alignment: Alignment.bottomRight,
      children: [
        profileImageWidget,
        Positioned(
          bottom: 0,
          right: 0,
          child: CircleAvatar(
            backgroundColor: Colors.purple,
            radius: 15,
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 15,
            ),
          ),
        ),
      ],
    ),
  ),
),

const SizedBox(height: 20),
Center(
  child: Text(
    'Username: $username',
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      fontFamily: 'Arial',
    ),
  ),
),
const SizedBox(height: 10),
Center(
  child: Text(
    'Email: $email',
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      fontFamily: 'Arial',
    ),
  ),
),

                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Update Username'),
                                content: TextField(
                                  controller: _usernameController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter new username',
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      final newUsername =
                                          _usernameController.text.trim();
                                      if (newUsername.isNotEmpty) {
                                        await _updateUsername(newUsername);
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text('Update'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('Update Username'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Update Email'),
                                content: TextField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter new email',
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      final newEmail =
                                          _emailController.text.trim();
                                      if (newEmail.isNotEmpty) {
                                        await _updateEmail(newEmail);
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text('Update'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('Update Email'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Update Password'),
                                content: TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: 'Enter new password',
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      final newPassword =
                                          _passwordController.text.trim();
                                      if (newPassword.isNotEmpty) {
                                        await _updatePassword(newPassword);
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text('Update'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('Update Password'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Delete Account'),
                                content:
                                    Text('Are you sure you want to delete your account?'),
                                actions: [
                                  TextButton(
                                    onPressed: _deleteAccount,
                                    child: Text('Delete'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('Delete Account'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: logout,
                        child: Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ), 
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}




