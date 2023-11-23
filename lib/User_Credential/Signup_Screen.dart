import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import '../Home_Screen.dart';
import 'Login.dart';

class RegistrationPage extends StatefulWidget {
  final String mobileNumber;

  RegistrationPage({required this.mobileNumber});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  TextEditingController countrycode = TextEditingController();
  late TextEditingController _mobileController;

  String? selectedGender;
  List<String> genderOptions = ['Male', 'Female'];

  File? _image; // Variable to store the selected image

  @override
  void initState() {
    countrycode.text = "+91";
    _mobileController = TextEditingController(text: widget.mobileNumber);
    super.initState();
  }

  Future<void> _signUp(BuildContext context) async {
    final String apiUrl = 'http://10.0.2.2:3000/api/users';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add form fields
      request.fields['name'] = _nameController.text;
      request.fields['email'] = _emailController.text;
      request.fields['mobile'] = _mobileController.text;
      request.fields['password'] = _passwordController.text;
      request.fields['gender'] = selectedGender!;

      // Add image file
      if (_image != null) {
        var fileStream = http.ByteStream(_image!.openRead());
        var length = await _image!.length();
        var multipartFile = http.MultipartFile('profileImage', fileStream, length,
            filename: _image!.path.split("/").last);
        request.files.add(multipartFile);
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(await response.stream.bytesToString());
        print("Response body: $jsonResponse");

        if (jsonResponse['success'] == 1) {
          Fluttertoast.showToast(
            msg: jsonResponse['message'],
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HomePage(mobileNumber: _mobileController.text),
            ),
          );
        } else {
          Fluttertoast.showToast(
            msg: jsonResponse['message'],
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Server Connection Error!",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (error) {
      print("Error during sign-up: $error");
      Fluttertoast.showToast(
        msg: "Error during sign-up",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _getImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _image = File(result.files.first.path!);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
        return false;
      },
      child: MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 120),
                Text(
                  'Register',
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
                        // Profile Image Upload
                        GestureDetector(
                          onTap: _getImage,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.teal,
                            child: _image == null
                                ? Icon(
                              Icons.add_a_photo,
                              size: 40,
                              color: Colors.white,
                            )
                                : ClipOval(
                              child: Image.file(
                                _image!,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Code for Entering Name
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              hintText: 'Enter Name',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value) {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        // Code for Entering Email
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter Email',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value) {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your email';
                              } else if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.mobile_friendly,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  width: 40,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: countrycode,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "|",
                                  style: TextStyle(
                                      fontSize: 33, color: Colors.grey),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _mobileController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Phone',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Gender',
                              prefixIcon: Icon(FontAwesomeIcons.venusMars),
                              border: OutlineInputBorder(),
                            ),
                            value: selectedGender,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedGender = newValue;
                              });
                            },
                            items: genderOptions.map((String gender) {
                              return DropdownMenuItem<String>(
                                value: gender,
                                child: Text(gender),
                              );
                            }).toList(),
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        // Code for Entering Password
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter Password ',
                              prefixIcon: Icon(Icons.password),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value) {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a password';
                              } else if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          child: MaterialButton(
                            minWidth: double.infinity,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await _signUp(context);
                              }
                            },
                            color: Colors.teal,
                            textColor: Colors.white,
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
