import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../components/text_field_label.dart';

class ProfilePage extends StatefulWidget {

  const ProfilePage({Key? key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase();

  User? _user;
  Map<String, dynamic>? _userData;
  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DatabaseReference userRef = _database.reference().child('users').child(user.uid);

      userRef.onValue.listen((event) {
        if (event.snapshot.value != null && event.snapshot.value is Map<dynamic, dynamic>) {
          setState(() {
            _userData = Map<String, dynamic>.from(event.snapshot.value! as Map<dynamic, dynamic>);
            _user = user;
            _isLoading = false; // Set loading state to false when data is fetched
          });
          _updateControllers(); // Update controllers when data is fetched
        }
      });
    }
  }

  // Function to update text controllers with user data
  void _updateControllers() {
    setState(() {
      if (_userData != null) {
        usernameController.text = _userData!['username'] ?? '';
        addressController.text = _userData!['address'] ?? '';
        mobileController.text = _userData!['mobile'] ?? '';
        nameController.text = _userData!['name'] ?? '';
        emailController.text = _userData!['email'] ?? '';
        passwordController.text = _userData!['password'] ?? '';
      }
    });
  }
  // Logout function
  void logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Logged out successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error logging out'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Update profile function
  void updateProfileDetails(BuildContext context) async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('User must be signed in'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Set loading state to true when starting profile update
    });

    try {
      // Prompt the user to re-enter their password for reauthentication
      String? password = await _showReauthenticateDialog(context);
      if (password == null) {
        // Reauthentication canceled
        return;
      }

      // Reauthenticate the user
      AuthCredential credential = EmailAuthProvider.credential(email: currentUser.email!, password: password);
      await currentUser.reauthenticateWithCredential(credential);

      // Update email in Firebase Authentication
      await currentUser.updateEmail(emailController.text);

      // Update password in Firebase Authentication
      await currentUser.updatePassword(passwordController.text);

      // Update profile information in Firebase Realtime Database
      DatabaseReference userRef = _database.reference().child('users').child(currentUser.uid);

      Map<String, dynamic> updatedUserData = {
        'username': usernameController.text,
        'name': nameController.text,
        'address': addressController.text,
        'mobile': mobileController.text,
        'email': emailController.text,
        'password': passwordController.text
      };

      await userRef.update(updatedUserData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Profile details updated successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error updating profile details'),
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false; // Set loading state to false after profile update
      });
    }
  }

  Future<String?> _showReauthenticateDialog(BuildContext context) async {
    String? password;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reauthenticate'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Please re-enter your password to continue:'),
              TextField(
                onChanged: (value) {
                  password = value;
                },
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(password);
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
    return password;
  }


  @override
  Widget build(BuildContext context) {

    return _isLoading
        ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching data
        : SafeArea(
          child: SingleChildScrollView(
                child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          
              const SizedBox(height: 10),
          
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        logout(context);
                      },
                      child: const Icon(
                        Icons.logout,
                        size: 25,
                      ),
                    ),
                  ],
                ),
              ),
          
              const SizedBox(height: 10),
          
          
              // logo
              const Icon(
                Icons.person,
                size: 100,
              ),
          
              const SizedBox(height: 20),
          
              // welcome back, you've been missed!
              Text(
                'Update Your Profile',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
          
              const SizedBox(height: 15),
          
              TextFieldLabel(text: "Email:"),
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),
          
              const SizedBox(height: 10),
          
              TextFieldLabel(text: "Password:"),
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: false,
              ),
          
              const SizedBox(height: 10),
              TextFieldLabel(text: "Username:"),
          
              MyTextField(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false,
              ),
          
              const SizedBox(height: 10),
              TextFieldLabel(text: "Name:"),
          
              MyTextField(
                controller: nameController,
                hintText: 'Name',
                obscureText: false,
              ),
          
              const SizedBox(height: 10),
              TextFieldLabel(text: "Address:"),
          
              MyTextField(
                controller: addressController,
                hintText: 'Address',
                obscureText: false,
              ),
          
              const SizedBox(height: 10),
              TextFieldLabel(text: "Mobile no:"),
          
              MyTextField(
                controller: mobileController,
                hintText: 'Mobile no',
                obscureText: false,
              ),
          
              const SizedBox(height: 15),
          
              MyButton(
                onTap: (){
                  updateProfileDetails(context);
                },
                text: _isLoading ? 'Updating...' : 'Update Details',
              ),
          
          
              const SizedBox(height: 15),
          
            ],
          ),
                ),
              ),
        );
  }
}
