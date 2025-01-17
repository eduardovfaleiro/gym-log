import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                  const Row(
                    children: [
                      Text('Não possui uma conta ainda? '),
                      InkWell(
                        child: Text(
                          'Cadastrar',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'E-mail'),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            suffixIcon: IconButton(onPressed: () {}, icon: const Icon(Icons.visibility)),
                          ),
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: () {}, child: const Text('Entrar')),
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
