import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Home_Screen.dart';
import 'Register_Send_OTP.dart';
import 'Signup_Screen.dart';
import 'forgot_password.dart';

// Code For Login Page.
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _passwordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // Login API Called Here
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final String apiUrl =
        'https://apip.trifrnd.com/Services/eng/sereng.php?apicall=login';

    // Simulate a delay of 1 second
    await Future.delayed(Duration(seconds: 1));

    final response = await http.post(Uri.parse(apiUrl),
        body: {
          "mobile": _mobileController.text,
          "password": _passwordController.text,
        });

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print("Response body: ${response.body}");

      print("Decoded data: $responseData");

      if (responseData == "OK") {
        // Login successful, you can navigate to the next screen
        print("Login successful");
        final user = json.decode(response.body)[0];
        try {
          final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setString('mobile', _mobileController.text);
        } catch (e) {
          // Handle the exception, e.g., print an error message.
          print('Error: $e');
        }


        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              mobileNumber: _mobileController.text,
            ),
          ),
        );
      } else {
        // Login failed, show an error message
        print("Login failed");
        Fluttertoast.showToast(
          msg: "Invalid mobile number or password!",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } else {
      // Handle error if the API call was not successful
      print("API call failed");
      Fluttertoast.showToast(
        msg: "Server Connction Error!",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press here
        // You can use the following code to exit the app:
        SystemNavigator.pop();
        return true;
      },
      child: MaterialApp(
        home: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.teal.shade300,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Form(
                  key: _formKey,

                  child: Column(
                    children: [

                      // Code for Enter Mobile number

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Mobile',
                            hintText: 'Enter Mobile Number',
                            prefixIcon: Icon(Icons.mobile_friendly),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (String value) {},
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a mobile';
                            } else if (value.length < 10) {
                              return 'Mobile number must be 10 Digits';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 30),

                      // Code for Enter Mobile number

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          controller: _passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter Password',
                            prefixIcon: Icon(Icons.password),
                            border: OutlineInputBorder(),
                            // Password visibility toggle
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                          onChanged: (String value) {},
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Please Enter Password'
                                : null;
                          },
                        ),
                      ),
                      // Forget Password class is called here
                      fogetpassword(context),

                      SizedBox(height: 30),


                      // Code for Login Button

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          onPressed: () async {
                            // Handle login logic here
                            if (_formKey.currentState!.validate()) {
                              // Show loading indicator
                              setState(() {
                                _isLoading = true;
                              });
                              // Perform the login
                              await _login();
                              // Hide loading indicator after login completes
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                          color: Colors.teal,
                          textColor: Colors.white,
                          child: _isLoading
                              ? const CircularProgressIndicator(
                            color: Colors.white,
                          ) // Show loading indicator when _isLoading is true
                              : const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  // MyPhone(),
                              RegistrationPage(mobileNumber: '',),
                            ),
                          );
                        },
                        child: Text(
                          'Not Registered? Register Here',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.redAccent[100],
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  // Forget password Link Declared here
  Widget fogetpassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight ,
      child: TextButton(
        child: Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.red),
          textAlign: TextAlign.right,
        ),
        onPressed: () {
          // Navigator.of(context).push(
          //   MaterialPageRoute(builder: (context) =>
          //   // ForgetPass(),
          //   ForgotPassMobVerify(),
          //   ),
          // );
        },
      ),
    );
  }
}
