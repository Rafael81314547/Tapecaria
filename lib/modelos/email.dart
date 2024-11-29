import 'package:tapecaria/modelos/produto.dart';
import 'package:url_launcher/url_launcher.dart';

class Email {
  Future<String?> sendEmail(
      Future<List<Produto>> futureCartItems, String email) async {
    try {
      List<Produto> produtos = await futureCartItems;

      final String subject = Uri.encodeComponent("Lista de Produtos");
      final String body = Uri.encodeComponent(
          "Olá,\n\nAqui está a lista de produtos:\n${produtos.map((p) => '- ${p.nome}: \$${p.preco}').join('\n')}");
      final Uri emailUri =
          Uri.parse("mailto:$email?subject=$subject&body=$body");

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        return "Não foi possível abrir o cliente de e-mail.";
      }
      return null;
    } catch (e) {
      return "Erro ao enviar o e-mail: $e";
    }
  }
}
