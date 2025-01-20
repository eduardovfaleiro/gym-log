import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_log/main.dart';
import 'package:gym_log/pages/authentication/register_page.dart';
import 'package:gym_log/utils/horizontal_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _invalidCredential = false;

  bool get isEmailValid => _emailController.text.isNotEmpty;
  bool get isPasswordValid => _passwordController.text.isNotEmpty;

  String? _invalidCredentialError() {
    if (!_invalidCredential) return null;

    if (!isEmailValid || !isPasswordValid) {
      return null;
    }

    return 'E-mail ou senha estão incorretos.';
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Gym Log',
                style: GoogleFonts.jockeyOne(
                  textStyle: TextStyle(
                      fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize, fontWeight: FontWeight.bold),
                ),

                // style: TextStyle(fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize, fontFamily: GoogleFonts.aBeeZeeTextTheme),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Text('Não possui uma conta ainda? '),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(context, HorizontalRouter(child: const RegisterPage()));
                        },
                        child: const Text(
                          'Cadastrar',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (email) {
                            String? invalidCredentialError = _invalidCredentialError();

                            if (invalidCredentialError != null) {
                              return invalidCredentialError;
                            }

                            if (!isEmailValid) {
                              return 'O e-mail deve ser preenchido.';
                            }
                            return null;
                          },
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'E-mail'),
                        ),
                        TextFormField(
                          controller: _passwordController,
                          validator: (password) {
                            String? invalidCredentialError = _invalidCredentialError();

                            if (invalidCredentialError != null) {
                              return invalidCredentialError;
                            }

                            if (password == null || password.isEmpty) {
                              return 'A senha deve ser preenchida.';
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              isSelected: _obscureText,
                              selectedIcon: const Icon(Icons.visibility_off),
                              icon: const Icon(Icons.visibility),
                            ),
                          ),
                          obscureText: _obscureText,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) return;

                              try {
                                final credential = await fa.signInWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );
                                _invalidCredential = false;
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'invalid-credential') {
                                  _invalidCredential = true;
                                }
                              }

                              _formKey.currentState!.validate();
                            },
                            child: const Text('Entrar')),
                      ),
                    ],
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Expanded(child: Divider(height: 0)),
                    SizedBox(width: 12),
                    Text('ou'),
                    SizedBox(width: 12),
                    Expanded(child: Divider(height: 0)),
                  ],
                ),
              ),
              OutlinedButton(
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/google_logo.svg',
                          height: 36,
                        ),
                        const Text('Entrar com Google'),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
