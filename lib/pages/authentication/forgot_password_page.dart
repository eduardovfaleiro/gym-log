// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gym_log/main.dart';
import 'package:gym_log/pages/authentication/auth_appbar.dart';
import 'package:gym_log/utils/show_info_dialog.dart';
import 'package:gym_log/widgets/loading_manager.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> with LoadingManager {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return LoadingPresenter(
      isLoadingNotifier: isLoadingNotifier,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Esqueci minha senha'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Para alterar a senha da sua conta, você precisa informar seu endereço de e-mail e acessar o e-mail enviado.',
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: TextFormField(
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return 'O e-mail deve ser preenchido.';
                    }
                    return null;
                  },
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () async {
                            runLoading(() async {
                              if (!_formKey.currentState!.validate()) return;

                              await fa.sendPasswordResetEmail(email: _emailController.text);
                              await showInfo(
                                context,
                                title: 'Recuperar senha',
                                content: 'Caso o e-mail informado esteja associado a uma conta existente, '
                                    'um e-mail para alterar senha foi enviado a ${_emailController.text}.',
                              );
                              Navigator.pop(context);
                            });
                          },
                          child: const Text('Enviar'))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
