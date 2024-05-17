import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum StateLogin { initial, success, error }

enum StateRegister { initial, success, error }

class AuthFirebaseProvider extends ChangeNotifier {
  final formKeyRegister = GlobalKey<FormState>();
  final formKeyLogin = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var loginState = StateLogin.initial;
  var registerState = StateRegister.initial;
  var uid = '';
  var email = '';
  var messageError = '';
  bool obscurePassword = true;

  void actionObscurePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void registerProcess(BuildContext context) async {
    if (formKeyRegister.currentState!.validate()) {
      try {
        UserCredential result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        User dataUser = result.user!;
        uid = dataUser.uid;
        email = emailController.text;
        registerState = StateRegister.success; // Kosongkan nilai form
        emailController.clear();
        passwordController.clear();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return GiffyDialog.image(
              Image.asset(
                'lib/assets/gif/register.gif',
                height: 250,
                fit: BoxFit.cover,
              ),
              title: const Text(
                'Register Berhasil',
                textAlign: TextAlign.center,
              ),
              content: Text(
                'Anda berhasil Register dengan email: $email dengan UID: $uid',
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } on FirebaseAuthException catch (error) {
        // loginState = StateLogin.error;
        registerState = StateRegister.error;
        messageError = error.message!;
      } catch (e) {
        // loginState = StateLogin.error;
        registerState = StateRegister.error;
        messageError = e.toString();
      }
    } else {
      showAlertError(context);
    }

    notifyListeners();
  }

  void loginProcess(BuildContext context) async {
    if (formKeyLogin.currentState!.validate()) {
      try {
        UserCredential result = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        User dataUser = result.user!;
        uid = dataUser.uid;
        email = emailController.text;
        loginState = StateLogin.success;
        // Kosongkan nilai form
        emailController.clear();
        passwordController.clear();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return GiffyDialog.image(
              backgroundColor: const Color.fromARGB(255, 244, 235, 153),
              Image.asset(
                'lib/assets/gif/login.gif',
                height: 250,
                fit: BoxFit.cover,
              ),
              title: const Text(
                'Login Berhasil',
                textAlign: TextAlign.center,
              ),
              content: Text(
                'Anda berhasil Login dengan email: $email dengan UID: $uid',
                textAlign: TextAlign.center,
              ),
              actions: [
                ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Colors.orange),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            );
          },
        );
      } on FirebaseAuthException catch (error) {
        loginState = StateLogin.error;
        messageError = error.message!;
      } catch (e) {
        loginState = StateLogin.error;
        messageError = e.toString();
      }
    } else {
      showAlertError(context);
    }
    notifyListeners();
  }

  void loginGoogle(BuildContext context) async {
    try {
      GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User dataUser = userCredential.user!;
      uid = dataUser.uid;
      email = emailController.text;
      loginState = StateLogin.success;
      // Kosongkan nilai form
      emailController.clear();
      passwordController.clear();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return GiffyDialog.image(
            Image.asset(
              'lib/assets/gif/login.gif',
              height: 250,
              fit: BoxFit.cover,
            ),
            title: const Text(
              'Login Berhasil',
              textAlign: TextAlign.center,
            ),
            content: Text(
              'Anda berhasil Login dengan email: $email dengan UID: $uid',
              textAlign: TextAlign.center,
            ),
            actions: [
              ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          );
        },
      );
    } on FirebaseAuthException catch (error) {
      loginState = StateLogin.error;
      messageError = error.message!;
    } catch (e) {
      loginState = StateLogin.error;
      messageError = e.toString();
    }

    notifyListeners();
  }
}

showAlertError(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return GiffyDialog.image(
        backgroundColor: const Color.fromARGB(255, 223, 236, 246),
        Image.asset(
          'lib/assets/gif/error.gif',
          height: 250,
          fit: BoxFit.cover,
        ),
        title: const Text(
          'Data Invalid !',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Periksa Kelengkapan Data !',
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.red),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ))
        ],
      );
    },
  );
}
