import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tapecaria/mensagens_modal/snackbar.dart';
import 'package:tapecaria/servicos/autenticacao_service.dart';
import 'package:tapecaria/telas/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formularioCadastro = GlobalKey<FormState>();

  final _nomeUsuarioController = TextEditingController();

  final _emailUsuarioController = TextEditingController();

  final _senhaUsuarioController = TextEditingController();

  final _confirmarSenhaController = TextEditingController();
  final _autenticacao = AutenticacaoService();

  // ignore: unused_field
  bool _isLoading = false;

  Future<void> _cadastrarUsuario() async {
    if (_formularioCadastro.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      var ocorreuErro = await _autenticacao.criarUsuario(
        _nomeUsuarioController.text,
        _emailUsuarioController.text,
        _senhaUsuarioController.text,
      );

      setState(() => _isLoading = false);

      if (ocorreuErro != null) {
        showSnackBar(context: context, message: ocorreuErro);
      } else {
        showSnackBar(
          context: context,
          message: "Cadastro feito com sucesso!",
          isError: false,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    }
  }

  String? _validarNomeUsuario(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'É necessário preencher o campo';
    }
    if (valor.length != valor.replaceAll(' ', '').length) {
      return 'O campo de usuário não deve ter espaços';
    }
    if (valor.length <= 2) {
      return 'Usuário deve ter mais que dois caracteres';
    }
    return null;
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
          child: SingleChildScrollView(
            child: Form(
              key: _formularioCadastro,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    child: const Icon(Icons.person_4,
                        size: 70, color: Colors.brown),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _nomeUsuarioController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_2_outlined, size: 20),
                      labelText: 'Nome de usuário',
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
                    validator: (String? valor) => _validarNomeUsuario(valor),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailUsuarioController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email_outlined, size: 20),
                      labelText: 'Seu melhor e-mail',
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
                    validator: (String? valor) => _validarCampoEmail(valor),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _senhaUsuarioController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
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
                    validator: (String? valor) => _validarCampoSenha(valor),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _confirmarSenhaController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.replay_rounded, size: 20),
                      labelText: 'Confirme sua senha',
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
                    validator: (String? valor) {
                      if (valor != _senhaUsuarioController.text) {
                        return 'As senhas estão diferentes';
                      }

                      return null;
                    },
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
                    onPressed: _cadastrarUsuario,
                    child: const Text(
                      'Cadastrar',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      'Realizar login',
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
      ),
    );
  }
}
