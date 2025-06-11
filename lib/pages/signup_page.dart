import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:voice_and_text_translator/components/my_button.dart';
import 'package:voice_and_text_translator/components/my_textfield.dart';
import 'package:voice_and_text_translator/pages/home_page.dart';
import 'package:voice_and_text_translator/pages/login_page.dart';

class SignupPage extends StatefulWidget {
  // SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();
  bool isLoading = false;

  void signUserUp(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    try {
      if (emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          usernameController.text.isEmpty ||
          nameController.text.isEmpty ||
          mobileController.text.isEmpty ||
          addressController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Please fill in all the required fields.'),
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      String userId = userCredential.user!.uid;

      DatabaseReference userRef = FirebaseDatabase.instance
          .reference()
          .child('users')
          .child(userId);

      userRef.set({
        'username': usernameController.text,
        'email': emailController.text,
        'name': nameController.text,
        'mobile': mobileController.text,
        'address': addressController.text,
        'password': passwordController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Account Created Successfully'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (error) {
      print('Error signing up user: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Something Went Wrong while Creating Account: '),
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),

                const Icon(
                  Icons.keyboard_voice,
                  size: 100,
                ),

                const SizedBox(height: 20),

                Text(
                  'Create an Account',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 15),

                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  controller: nameController,
                  hintText: 'Name',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  controller: addressController,
                  hintText: 'Address',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  controller: mobileController,
                  hintText: 'Mobile no',
                  obscureText: false,
                ),

                const SizedBox(height: 15),

                MyButton(
                  onTap: () {
                    signUserUp(context);
                  },
                  text: isLoading ? "Logging in..." : "Register",
                ),

                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already Have an Account',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LoginPage()));
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
