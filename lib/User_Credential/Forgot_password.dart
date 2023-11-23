

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import 'Login.dart';

// Code For Checking The OTP ON Forget Password PAGE
class ForgotPassOTP extends StatefulWidget {

  @override
  State<ForgotPassOTP> createState() => _MyOtpState();
}

class _MyOtpState extends State<ForgotPassOTP> {
  bool isVerifying = false; // Variable to track verification progress

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    var code="";

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
            children: [const Text('Verify Code',
              style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),

              const SizedBox(height: 10,),
              Column(
                children: [
                  Text('Please enter the code we just sent to email!',
                    style: TextStyle(fontSize: 16,
                        color: Colors.black45
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text('User@gmail.com',
                    style: TextStyle(fontSize: 16,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  )

                ],
              ),
              const SizedBox(height: 30,),
              // Text('Mobile Number: ${widget.mobileNumber}'),
              const SizedBox(height: 20,),

              Pinput(
                length: 6,
                // pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: true,
                onChanged: (value){
                  code= value;
                },

              ),
              const SizedBox(height: 30,),
              Text(
                "Didn't recived OTP?",
                style: TextStyle(
                  color: Colors.black45,
                ),
              ),
              GestureDetector(
                onTap: () {
                },
                child: Text(
                  "Resend Code",
                  style: TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

              const SizedBox(height: 30,),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(onPressed: () async {
                  setState(() {
                    isVerifying = true;
                  });
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) =>
                  //         // LoginScreen()
                  //     ));

                  // Navigator.pushNamed(context, "otp");
                },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  child: isVerifying
                      ? CircularProgressIndicator() // Show loading indicator
                      : const Text('Verify '),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

