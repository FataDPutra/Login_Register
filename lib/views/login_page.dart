import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:login_register/controllers/auth_firebase_provider.dart';
import 'package:login_register/views/register_page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var authProvider = context.watch<AuthFirebaseProvider>();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 79, 187, 241),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Form(
          key: authProvider.formKeyLogin,
          child: ListView(
            children: [
              SvgPicture.asset(
                'lib/assets/images/images.svg',
                height: 250,
              ),
              const Text(
                'Welcome Back !',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 20,
                  color: Color.fromARGB(255, 51, 58, 115),
                ),
              ),
              const Text(
                'Login',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 51, 58, 115),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                  controller: authProvider.emailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Field tidak boleh kosong';
                    }
                    return null;
                  },
                  autofocus: true,
                  decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Color.fromARGB(255, 51, 58, 115),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      hintText: 'Email',
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 101, 101, 101)),
                      suffixIcon: Icon(Icons.email),
                      filled: true,
                      fillColor: Color.fromARGB(255, 255, 236, 170),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10))))),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                  controller: authProvider.passwordController,
                  obscureText: authProvider.obscurePassword,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Field tidak boleh kosong';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Color.fromARGB(255, 51, 58, 115),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      hintText: 'Password',
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 101, 101, 101)),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 236, 170),
                      suffixIcon: IconButton(
                          onPressed: () {
                            context
                                .read<AuthFirebaseProvider>()
                                .actionObscurePassword();
                          },
                          icon: Icon(authProvider.obscurePassword == true
                              ? Icons.visibility_off
                              : Icons.visibility)),
                      border: const OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10))))),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 214, 95, 31),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  context.read<AuthFirebaseProvider>().loginProcess(context);
                },
                child: const Text("Login",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 141, 203, 136),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () =>
                    context.read<AuthFirebaseProvider>().loginGoogle(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'lib/assets/icons/google.svg',
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Login with Google",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 12, 71, 130),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ));
                },
                child: const Text("Register Page",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              const SizedBox(
                height: 10,
              ),
              bodyMessage(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget bodyMessage(BuildContext context) {
    var state = context.watch<AuthFirebaseProvider>().loginState;
    var email = context.watch<AuthFirebaseProvider>().email;
    var uid = context.watch<AuthFirebaseProvider>().uid;
    switch (state) {
      case StateLogin.initial:
        return const SizedBox();
      case StateLogin.success:
        return Text(
          'Hello, $email dengan UID $uid',
          textAlign: TextAlign.center,
        );
      case StateLogin.error:
        return Text(context.watch<AuthFirebaseProvider>().messageError);
      default:
        return const SizedBox();
    }
  }
}
