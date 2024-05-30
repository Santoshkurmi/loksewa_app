import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loksewa/screen/home/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignUpScreen> {
  String email = '', password = '',name='',phone='';
  String? errorEmail,errorPassword,errorName,errorPhone;
  bool isLoading = false;

  Future<UserCredential?> handleEmailPasswordSignup() async {
    if(email.isEmpty){ setState(() {
      errorEmail = 'Email cannot be empty';
    });
      return null;
    }

    if(password.length<5){
      setState(() {
        errorPassword = 'Password must be greater than 5 chars';
      });
      return null;
    }
    
    if(name.length<5){
      setState(() {
        errorName = 'Name must be greater than 4 chars';
      });
      return null;
    }

    // if(phone.isNotEmpty && phone.length<10){
    //   setState(() {
    //     errorPhone = 'Phone must be empty or valid phone number';
    //   });
    //   return null;
    // }
    
    setState(() {
      isLoading = true;
      errorEmail=null;errorPassword=null;errorName=null;
    });
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user?.sendEmailVerification();
      await credential.user?.updateDisplayName(name);

   await FirebaseAuth.instance.signOut(); 
   await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Registration Successfull"),
          content: Text("A verification email is sent.\nPlease verify the email and then try logging."),
          actions: [ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("Ok"))],
          backgroundColor: Colors.green.shade600,
          );
      },
    );
      Navigator.pop(context);
      return null;
    } //tru

    on FirebaseAuthException catch (e) {
      errorPassword = null;
      errorEmail = null;
      // print(e.code);
      setState(() {
        isLoading = false;
      });
      if (e.code == 'weak-password') {
        setState(() {
          errorPassword = 'The password is too weak';
        });
      } else if (e.code == 'email-already-in-use') {
          setState(() {
           errorEmail = 'The email already exists'; 
          });
      }//else if
      else if(e.code =='invalid-email'){
        setState(() {
          errorEmail = 'The email is invalid';
        });
      }
      return null;
    } catch (error) {
      // print(error);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
      setState(() {
        isLoading = false;
      });
      return null;
    } //catc
  } //handle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FractionallySizedBox(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              "Register",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 40,
            ),
            _buildTextInputs()
          ],
        ),
      ),
    ));
  }

  _buildTextInputs() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(children: [
          TextField(
            // minLines: 1,
            cursorColor: Colors.black,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => email = value,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Enter new email',
              errorText: errorEmail,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              prefixIcon: Icon(Icons.email),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            // minLines: 1,
            obscureText: true,
            cursorColor: Colors.black,
            onChanged: (value) => password = value,
            decoration: InputDecoration(
              hintText: 'Enter new password',
              labelText: 'Password',
              errorText: errorPassword,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              prefixIcon: Icon(Icons.password),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          TextField(
            // minLines: 1,
            // obscureText: true,
            cursorColor: Colors.black,
            onChanged: (value) => name = value,
            decoration: InputDecoration(
              hintText: 'Enter your name',
              labelText: 'Name',
              errorText: errorName,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              prefixIcon: Icon(Icons.password),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          // TextField(
          //   // minLines: 1,
          //   obscureText: true,
          //   keyboardType: TextInputType.number,
          //   cursorColor: Colors.black,
          //   onChanged: (value) => phone = value,
          //   decoration: InputDecoration(
          //     hintText: 'Enter your phone(Optional)',
          //     labelText: 'Phone(optional)',
          //     errorText: errorPhone,
          //     border: OutlineInputBorder(
          //         borderRadius: BorderRadius.all(Radius.circular(10))),
          //     prefixIcon: Icon(Icons.password),
          //   ),
          // ),
          // SizedBox(
          //   height: 15,
          // ),
          MaterialButton(
            padding: EdgeInsets.only(top: 18, bottom: 18),
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () async {
              // Navigator.pop(context);
                handleEmailPasswordSignup();
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            color: Colors.purple.shade700,
            elevation: 5.0,
            child: isLoading
                ? CircularProgressIndicator()
                : Text(
                    "Register",
                    style: TextStyle(color: Colors.white),
                  ),
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Already have Account?"),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ]));
  }
}
