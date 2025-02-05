// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gym_log/main.dart';
import 'package:gym_log/pages/authentication/auth_appbar.dart';
import 'package:gym_log/pages/authentication/login_page.dart';
import 'package:gym_log/pages/authentication/register_page.dart';
import 'package:gym_log/utils/routers.dart';
import 'package:gym_log/utils/show_error.dart';
import 'package:gym_log/utils/show_info_dialog.dart';
import 'package:gym_log/widgets/auth_page_manager.dart';
import 'package:gym_log/widgets/brightness_manager.dart';
import 'package:gym_log/widgets/loading_manager.dart';
import 'package:gym_log/widgets/text_link.dart';

import '../../services/google_sign_in_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with LoadingManager {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  bool get isEmailValid => _emailController.text.isNotEmpty;
  bool get isPasswordValid => _passwordController.text.isNotEmpty;

  bool _weakPassword = false;
  bool _emailInUse = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return LoadingPresenter(
      isLoadingNotifier: isLoadingNotifier,
      child: Scaffold(
        appBar: const AuthAppBar(),
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
                                Navigator.pop(context);
                                // AuthPageManager.of(context).updatePage(AuthPage.login);
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
                                  if (!isEmailValid) {
                                    return 'O e-mail deve ser preenchido.';
                                  }

                                  if (_emailInUse) {
                                    return 'Já existe uma conta com este e-mail.';
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
                                  if (password == null || password.isEmpty) {
                                    return 'A senha deve ser preenchida.';
                                  }

                                  if (_weakPassword) {
                                    return 'A senha deve ter no mínimo 6 caracteres.';
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
                          padding: EdgeInsets.only(top: 6, bottom: 24),
                          child: Text(''),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () async {
                                    setLoading(true);
                                    // runLoading(() async {
                                    _weakPassword = false;
                                    _emailInUse = false;
                                    if (!_formKey.currentState!.validate()) return;

                                    try {
                                      final credential = await fa.createUserWithEmailAndPassword(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      );
                                      await credential.user!.sendEmailVerification();
                                      Navigator.pop(context);
                                      showInfo(
                                        context,
                                        title: 'Enviamos uma verificação de e-mail',
                                        content:
                                            'Para continuar, acesse o link no e-mail que enviamos a ${credential.user!.email}.',
                                      );
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'weak-password') {
                                        _weakPassword = true;
                                      } else if (e.code == 'email-already-in-use') {
                                        _emailInUse = true;
                                      } else if (e.code == 'network-request-failed') {
                                        showError(
                                          context,
                                          content: 'Não foi possível estabelecer conexão com o servidor. '
                                              'Por favor, cheque sua conexão e tente novamente.',
                                        );
                                      }
                                    }

                                    _formKey.currentState!.validate();
                                    // });
                                    setLoading(false);
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
                      onPressed: () async {
                        setLoading(true);
                        // runLoading(() async {
                        var signIn = await GoogleSignInService().signIn(context);

                        if (signIn.result) {
                          Navigator.pop(context);
                        } else if (signIn.message.isNotEmpty) {
                          showError(context, content: signIn.message);
                        }
                        // });
                        setLoading(false);
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
      ),
    );
  }
}
