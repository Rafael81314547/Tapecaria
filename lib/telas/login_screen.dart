import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tapecaria/mensagens_modal/snackbar.dart';
import 'package:tapecaria/servicos/autenticacao_service.dart';
import 'package:tapecaria/telas/home_screen.dart';
import 'package:tapecaria/telas/registro_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailLoginController = TextEditingController();
  final _senhaLoginController = TextEditingController();
  final AutenticacaoService service = AutenticacaoService();
  final _formularioLogin = GlobalKey<FormState>();

  Future<void> _validarLogin() async {
    String email = _emailLoginController.text;
    String senha = _senhaLoginController.text;

    try {
      if (_formularioLogin.currentState?.validate() ?? false) {
        String? ocorreuErro = await service.realizarLogin(email, senha);

        if (ocorreuErro != null) {
          showSnackBar(context: context, message: ocorreuErro);
        } else {
          showSnackBar(
            context: context,
            message: "Login feito com sucesso!",
            isError: false,
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(),
            ),
          );
        }
      }
    } catch (e) {
      showSnackBar(context: context, message: "Unexpected error: $e");
    }
  }

  String? _validarCampoEmail(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'É necessário preencher o campo';
    }
    if (!valor.contains('@')) {
      return 'O campo deve ser um e-mail válido';
    }
    return null;
  }

  String? _validarCampoSenha(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'É necessário preencher o campo';
    }
    if (valor.length < 7) {
      return 'A senha deve ser maior que 6 dígitos';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          "Art's do Tear",
          style: GoogleFonts.greatVibes(
            fontSize: 40.0,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: 300,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 2,
                blurRadius: 4,
              ),
            ],
          ),
          child: Form(
            key: _formularioLogin,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[200],
                  child: const Icon(Icons.card_giftcard_outlined,
                      size: 70, color: Colors.brown),
                ),
                Text(
                  'Realize o Login',
                  style: GoogleFonts.greatVibes(
                      fontSize: 30.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _emailLoginController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email, size: 20),
                    labelText: 'Email',
                    labelStyle: const TextStyle(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.brown),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.brown, width: 2),
                    ),
                  ),
                  validator: (String? valorDoCampoEmail) =>
                      _validarCampoEmail(valorDoCampoEmail),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _senhaLoginController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock, size: 20),
                    labelText: 'Senha',
                    labelStyle: const TextStyle(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.brown),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.brown, width: 2),
                    ),
                  ),
                  validator: (String? valorDoCampoSenha) =>
                      _validarCampoSenha(valorDoCampoSenha),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _validarLogin,
                  child: const Text(
                    'Entrar',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: const Text(
                    'Cadastrar-se',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
