import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String mobileNumber;

  HomePage({required this.mobileNumber});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final String apiUrl = 'http://10.0.2.2:3000/api/users/${widget.mobileNumber}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse.containsKey('message')) {
          // Handle user not found
          print(jsonResponse['message']);
        } else {
          setState(() {
            userData = jsonResponse;
          });
        }
      } else {
        // Handle server connection error
        print('Server Connection Error: ${response.statusCode}');
      }
    } catch (error) {
      print("Error fetching user data: $error");
      // Handle error
    }
  }

  Widget buildUserImage() {
    if (userData.containsKey('profileImage')) {
      String base64Image = userData['profileImage'];
      Uint8List bytes = base64Decode(base64Image);
      return Image.memory(bytes, width: 100, height: 100, fit: BoxFit.cover);
    } else {
      return Icon(Icons.person, size: 100, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildUserImage(),
            SizedBox(height: 20),
            Text('ID: ${userData['id']}'),
            Text('Name: ${userData['name']}'),
            Text('Email: ${userData['email']}'),
            Text('Mobile: ${userData['mobile']}'),
            Text('Gender: ${userData['gender']}'),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}
