import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loksewa/screen/auth/sign_screen.dart';
import 'package:loksewa/screen/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '', password = '';
  String? errorEmail, errorPassword;
  bool isLoading = false;

  void passwordLogin() async {
    if (email.length < 3) {
      setState(() {
        errorEmail = "Please enter valid email address";
      });
      return;
    }
    if (password.length < 5) {
      setState(() {
        errorPassword = "Password must be greater than 5 and strong";
      });
      return;
    }

    setState(() {
      isLoading=true;
      errorEmail = null;
      errorPassword = null;
    });

    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user?.emailVerified == null ||
          userCredential.user?.emailVerified == false) {
        await FirebaseAuth.instance.signOut();
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Email not verified"),
              content: Text(
                  "A verification email is sent.\nPlease verify the email and then try logging."),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Ok"))
              ],
              backgroundColor: Colors.green.shade600,
            );
          },
        ); //showDialgoog
        setState(() {
          isLoading = false;
        });
      return;
      } //checking
      
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login is Successfull")));
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
      
    } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
        });
      print(e.code);
      if (e.code == "invalid-email") {
        setState(() {
          errorEmail = "Email is invalid";
        });
      } //if
      else if (e.code == "invalid-credential") {
        setState(() {
          errorEmail = "Email or password is wrong";
        });
      } else {
        setState(() {
          errorEmail = e.code;
        });
      }
    } catch (error) {
        setState(() {
          isLoading = false;
        errorEmail = error.toString();
        });
    }
  } //passwordlogin

  Future<UserCredential?> handleGoogleSignIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      await FirebaseAuth.instance.signInWithCredential(credential);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login is Successfull")));
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
      return null;
    } //tru
    on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code)));
    } catch (error) {
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
              "Login",
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
      child: Column(
        children: [
          TextField(
            // minLines: 1,
            cursorColor: Colors.black,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => email = value,
            decoration: InputDecoration(
              labelText: 'Email',
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
              hintText: 'Enter your password',
              labelText: 'Password',
              errorText: errorPassword,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              prefixIcon: Icon(Icons.password),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Text("Forgot Password?"),
          ),
          SizedBox(
            height: 10,
          ),
          MaterialButton(
            padding: EdgeInsets.only(top: 18, bottom: 18),
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () async {
              passwordLogin();
              // Navigator.pop(context);
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            color: Colors.purple.shade700,
            elevation: 5.0,
            child: isLoading
                ? CircularProgressIndicator()
                : Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (con) => SignUpScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Register"),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
              onTap: () {
                handleGoogleSignIn();
              },
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Or login using'),
              )),
          InkWell(
            onTap: () {
              handleGoogleSignIn();
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FaIcon(
                FontAwesomeIcons.google,
                color: Colors.purple.shade600,
                size: 30,
              ),
            ),
          )
        ],
      ),
    );
  }
}
