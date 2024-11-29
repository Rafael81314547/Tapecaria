import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AutenticacaoService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> criarUsuario(
      String nomeUsuario, String email, String senha) async {
    try {
      UserCredential novoUsuario = await _auth.createUserWithEmailAndPassword(
          email: email, password: senha);

      await novoUsuario.user!.updateDisplayName(nomeUsuario);
    } on FirebaseAuthException catch (erro) {
      return _tratarErrosFirebase(erro);
    } catch (erro) {
      return "Erro desconhecido: $erro";
    }
    return null;
  }

  Future<String?> realizarLogin(String email, String senha) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      final prefs = await SharedPreferences.getInstance();

      String? username = userCredential.user?.displayName;

      if (username != null) {
        await prefs.setString('username', username);
      }

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  String _tratarErrosFirebase(FirebaseAuthException erro) {
    switch (erro.code) {
      case 'email-already-in-use':
        return "O e-mail já está sendo usado por outra conta.";
      case 'weak-password':
        return "A senha é muito fraca. Escolha uma senha mais forte.";
      case 'invalid-email':
        return "O formato do e-mail é inválido.";
      case 'user-not-found':
        return "Nenhuma conta encontrada com este e-mail.";
      case 'wrong-password':
        return "A senha está incorreta.";
      default:
        return "Erro: ${erro.message}";
    }
  }
}
