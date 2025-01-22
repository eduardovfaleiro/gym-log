import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_log/main.dart';
import 'package:gym_log/pages/authentication/login_page.dart';
import 'package:gym_log/pages/authentication/register_page.dart';
import 'package:gym_log/utils/routers.dart';
import 'package:gym_log/widgets/brightness_manager.dart';
import 'package:gym_log/widgets/text_link.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  final bool _invalidCredential = false;

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
    final brightnessManager = BrightnessManager.of(context);

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Bem-vindo ao', style: Theme.of(context).textTheme.bodyMedium),
                    SvgPicture.asset(
                      'assets/gym_log_horizontal_logo.svg',
                      height: 24,
                      fit: BoxFit.fitHeight,
                      colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    brightnessManager.updateBrightness(brightnessManager.brightness);
                  },
                  icon: const Icon(Icons.light_mode),
                  selectedIcon: const Icon(Icons.dark_mode),
                  isSelected: brightnessManager.brightness == Brightness.dark,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Cadastrar uma conta',
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Text('Já possui uma conta? '),
                          TextLink(
                            'Entrar',
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                FadeRouter(child: const LoginPage()),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
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
                            const SizedBox(height: 8),
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
                      const Padding(
                        padding: EdgeInsets.only(top: 6, bottom: 16),
                        child: Text(''),
                      ),
                      // Container(
                      //   padding: const EdgeInsets.only(top: 8, bottom: 16),
                      //   alignment: Alignment.centerRight,
                      //   child: TextLink(
                      //     'Esqueceu sua senha?',
                      //     onTap: () {
                      //       Navigator.pushReplacement(context, HorizontalRouter(child: const RegisterPage()));
                      //     },
                      //   ),
                      // ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () async {
                                  // if (!_formKey.currentState!.validate()) return;

                                  // try {
                                  //   final credential = await fa.signInWithEmailAndPassword(
                                  //     email: _emailController.text,
                                  //     password: _passwordController.text,
                                  //   );
                                  //   _invalidCredential = false;
                                  // } on FirebaseAuthException catch (e) {
                                  //   if (e.code == 'invalid-credential') {
                                  //     _invalidCredential = true;
                                  //   }
                                  // }

                                  // _formKey.currentState!.validate();
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
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 6)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 36,
                          child: SvgPicture.asset(
                            'assets/google_logo.svg',
                            height: 36,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        const Text('Cadastrar com Google'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
