// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gym_log/main.dart';
import 'package:gym_log/pages/authentication/auth_appbar.dart';
import 'package:gym_log/pages/authentication/forgot_password_page.dart';
import 'package:gym_log/pages/authentication/register_page.dart';
import 'package:gym_log/services/google_sign_in_service.dart';
import 'package:gym_log/utils/routers.dart';
import 'package:gym_log/utils/show_error.dart';
import 'package:gym_log/utils/show_info_dialog.dart';
import 'package:gym_log/widgets/auth_page_manager.dart';
import 'package:gym_log/widgets/brightness_manager.dart';
import 'package:gym_log/widgets/loading_manager.dart';
import 'package:gym_log/widgets/text_link.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with LoadingManager {
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
    return LoadingPresenter(
      isLoadingNotifier: isLoadingNotifier,
      child: Scaffold(
        appBar: const AuthAppBar(),
        body: Padding(
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
                          'Entrar na conta',
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
                          const Text('Não possui uma conta ainda? '),
                          TextLink(
                            'Cadastrar',
                            onTap: () {
                              // AuthPageManager.of(context).updatePage(AuthPage.register);
                              Navigator.push(
                                context,
                                FadeRouter(child: const RegisterPage()),
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
                      Container(
                        padding: const EdgeInsets.only(top: 8, bottom: 24),
                        alignment: Alignment.centerRight,
                        child: TextLink(
                          'Esqueceu sua senha?',
                          onTap: () {
                            Navigator.push(context, FadeRouter(child: const ForgotPasswordPage()));
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  runLoading(() async {
                                    _invalidCredential = false;
                                    if (!_formKey.currentState!.validate()) return;

                                    try {
                                      final credential = await fa.signInWithEmailAndPassword(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      );

                                      if (credential.user != null && !credential.user!.emailVerified) {
                                        await fa.signOut();
                                        showInfo(
                                          context,
                                          title: 'E-mail não verificado',
                                          content:
                                              'Para continuar, acesse o link no e-mail enviado a ${credential.user!.email}.',
                                        );
                                      }
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'invalid-credential') {
                                        _invalidCredential = true;
                                      } else if (e.code == 'network-request-failed') {
                                        showError(
                                          context,
                                          content: 'Não foi possível estabelecer conexão com o servidor. '
                                              'Por favor, cheque sua conexão e tente novamente.',
                                        );
                                      }
                                    }

                                    _formKey.currentState!.validate();
                                  });
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
                    onPressed: () async {
                      runLoading(() async {
                        var signIn = await GoogleSignInService().signIn(context);

                        if (signIn.result) {
                          Navigator.pop(context);
                        } else if (signIn.message.isNotEmpty) {
                          showError(context, content: signIn.message);
                        }
                      });
                    },
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
                        const Text('Entrar com Google'),
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
