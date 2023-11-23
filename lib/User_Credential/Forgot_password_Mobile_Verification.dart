import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Forgot_password.dart';

// Code for Entering the number and sending the OTP for Forget Password page
class ForgotPassMobileVerify extends StatefulWidget {
  const ForgotPassMobileVerify({super.key});

  static String verify="";

  @override
  State<ForgotPassMobileVerify> createState() => _ForgotPassEmailVerify();
}

class _ForgotPassEmailVerify extends State<ForgotPassMobileVerify> {
  TextEditingController countrycode = TextEditingController();
  var _mobileController="";
  bool showProgressIndicator = false; // Declare the variable

  // final TextEditingController _mobileController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    countrycode.text="+91";
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon:   const Icon(Icons.arrow_back_ios,color: Colors.black,),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25,right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const SizedBox(height: 10,),

              const Text('Email Verification',
                style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),

              const SizedBox(height: 10,),
              const Text('We need to verify your Email before Reseating Password !',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,),
              const SizedBox(height: 30,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (String value){

                  },
                  validator: (value){
                    return value!.isEmpty ? 'Please  Enter Email' : null;
                  },
                ),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children:[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: ElevatedButton(
                        onPressed: () async {

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>
                                  ForgotPassOTP()));

                          setState(() {
                            showProgressIndicator = true; // Start the verification, show the indicator
                          });
                          // Navigator.pushNamed(context, "otp");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                        child: const Text('Send the code',
                          style: TextStyle(
                            // color: Colors.,
                            fontSize: 16,
                          ),),
                      ),
                    ),
                    // Display CircularProgressIndicator while verifying
                    if (showProgressIndicator) // You need to conditionally display it
                      const CircularProgressIndicator(),
                  ],
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(builder: (context) =>
                  //       MyOtp2(mobileNumber: _mobileController,),),
                  // );
                ),
              ),
              const SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}