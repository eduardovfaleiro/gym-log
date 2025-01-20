import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gym_log/main.dart';
import 'package:gym_log/pages/authentication/login_page.dart';
import 'package:gym_log/utils/horizontal_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _invalidCredential = false;

  bool get isEmailValid => _emailController.text.isNotEmpty;
  bool get isPasswordValid => _passwordController.text.isNotEmpty;

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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Text('Já possui uma conta? '),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(context, BackHorizontalRouter(child: const LoginPage()));
                        },
                        child: const Text(
                          'Entrar',
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
                            return null;
                          },
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'E-mail'),
                        ),
                        TextFormField(
                          controller: _passwordController,
                          validator: (password) {
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
                            child: const Text('Cadastrar')),
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
