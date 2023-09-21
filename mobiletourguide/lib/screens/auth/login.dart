import 'package:mobiletourguide/constants/colors.dart';
import 'package:mobiletourguide/constants/styles.dart';
import 'package:mobiletourguide/constants/text.dart';
import 'package:mobiletourguide/services/authservice.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  final Function toggle;
  const Login({Key? key, required this.toggle}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // reference for the AuthService
  final AuthService _auth = AuthService();

  // form key
  final _formKey = GlobalKey<FormState>();
  // define states
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          // Back Button
          Positioned(
            top: 40, // Adjust the top position as needed
            left: 10, // Adjust the left position as needed
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // Navigate to the previous screen
              },
            ),
          ),
          // Logo Container
          Positioned(
            top: 10, // Adjust the top position as needed
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.2,
            child: Center(
              child: Container(
                child: const Text(
                  logo,
                  style: descBStyle,
                ),
              ),
            ),
          ),
          // Align Widgets
          Positioned(
            top: MediaQuery.of(context).size.height * 0.20,
            left: 20,
            right: 0,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: const Text(
                      desc,
                      style: greet,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: const Text(
                      descBold,
                      style: descBStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Card Component
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: 0,
            right: 0,
            bottom: 0,
            child: Card(
              elevation: 8,
              margin: EdgeInsets.all(0.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Email
                      TextFormField(
                        decoration: txtInputDeco.copyWith(labelText: "Email"),
                        validator: (value) => value?.isEmpty == true
                            ? "Enter a valid email"
                            : null,
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      // Password
                      TextFormField(
                        obscureText: true,
                        decoration:
                            txtInputDeco.copyWith(labelText: "Password"),
                        validator: (value) =>
                            value!.length < 6 ? "Enter a valid password" : null,
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                      ),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red),
                      ),
                      // Google
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Login with Social accounts",
                        style: descStyle,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Center(
                          child: Image.asset(
                            'assets/images/google.png',
                            height: 50,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account yet?",
                            style: descStyle,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                  color: mainBlue, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      // Button
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          dynamic result = await _auth
                              .signInWithEmailAndPassword(email, password);

                          if (result == null) {
                            setState(() {
                              error = "Invalid email or password";
                            });
                          }
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: textLight,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 2, color: mainYellow),
                          ),
                          child: const Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          dynamic result = await _auth.signInAnonymous();
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: textLight,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 2, color: mainYellow),
                          ),
                          child: const Center(
                            child: Text(
                              "Login as Guest",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
