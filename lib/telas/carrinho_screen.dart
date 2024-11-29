import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tapecaria/mensagens_modal/snackbar.dart';
import 'package:tapecaria/modelos/email.dart';
import 'package:tapecaria/servicos/carrinho_service.dart';
import 'package:tapecaria/servicos/usuario_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tapecaria/modelos/produto.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  UserService usuarioService = UserService();
  CarrinhoService carrinhoService = CarrinhoService();
  late String userId;
  late Future<List<Produto>> cartItems;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    cartItems = carrinhoService.todos(userId); // Carregar os itens do carrinho
  }

  // Função para remover um produto do carrinho
  Future<void> _deletarItem(String idCarrinho) async {
    await carrinhoService.deletar(idCarrinho);
    setState(() {
      cartItems = carrinhoService
          .todos(userId); // Atualizar a lista de itens do carrinho
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          "Meu Carrinho",
          style: GoogleFonts.greatVibes(
            fontSize: 40.0,
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<List<Produto>>(
        future: cartItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar os produtos.'));
          }

          if (!snapshot.hasData || snapshot.data?.isEmpty == true) {
            return const Center(child: Text('Carrinho vazio.'));
          }

          var products = snapshot.data;

          return ListView.builder(
            itemCount: products?.length ?? 0,
            itemBuilder: (context, index) {
              var produto = products?[index];

              return CartItemTile(
                productName: produto?.nome ?? 'Produto sem nome',
                productQuantity:
                    1, // Aqui você deve alterar para a quantidade correta do carrinho
                productPrice: produto?.preco ?? 0.0,
                onDelete: () {
                  carrinhoService.deletarL(
                      idProduto: produto?.id ?? '', idUsuario: userId);

                  setState(() {
                    cartItems = carrinhoService.todos(userId);
                  });
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Email email = Email();
            User? usuario = usuarioService.getUserId();
            Future<String?> ocorreuErro =
                email.sendEmail(cartItems, usuario!.email ?? '');

            if (ocorreuErro == null) {
              showSnackBar(
                  context: context,
                  message: 'E-mail enviado com sucesso!',
                  isError: false);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Enviar por e-mail',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  final String productName;
  final int productQuantity;
  final double productPrice;
  final VoidCallback onDelete;

  CartItemTile({
    required this.productName,
    required this.productQuantity,
    required this.productPrice,
    required this.onDelete, // Recebe o callback
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          productName,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.brown,
          ),
        ),
        subtitle: Text(
          'Quantidade: $productQuantity',
          style: const TextStyle(color: Colors.brown),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'R\$ ${productPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
