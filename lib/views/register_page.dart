import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:login_register/controllers/auth_firebase_provider.dart';
import 'package:login_register/views/login_page.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    var authProvider = context.watch<AuthFirebaseProvider>();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 12, 71, 130),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Form(
          key: authProvider.formKeyRegister,
          child: ListView(
            children: [
              SvgPicture.asset(
                'lib/assets/images/images.svg',
                height: 250,
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Hello !!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 236, 170),
                    fontSize: 18,
                    fontStyle: FontStyle.italic),
              ),
              const Text(
                'Register Page',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 236, 170),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                  controller: authProvider.emailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Field tidak boleh kosong';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.black),
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
                          borderSide: BorderSide(width: 2, color: Colors.black),
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
                height: 40,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 239, 88, 88),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  context.read<AuthFirebaseProvider>().registerProcess(context);
                },
                child: const Text("Register",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 79, 187, 241),
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
                        builder: (context) => const LoginPage(),
                      ));
                },
                child: const Text("Login Page",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 241, 136, 79),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10), // Ubah angka sesuai dengan radius yang diinginkan
                  ),
                  minimumSize: const Size(double.infinity,
                      50), // Ubah nilai tinggi sesuai kebutuhan
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
              bodyMessage(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget bodyMessage(BuildContext context) {
    var state = context.watch<AuthFirebaseProvider>().registerState;
    var email = context.watch<AuthFirebaseProvider>().email;
    var uid = context.watch<AuthFirebaseProvider>().uid;
    switch (state) {
      case StateRegister.initial:
        return const SizedBox();
      case StateRegister.success:
        return Text(
          'Hello, $email dengan UID $uid',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        );
      case StateRegister.error:
        return Text(
          context.watch<AuthFirebaseProvider>().messageError,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        );
      default:
        return const SizedBox();
    }
  }
}
