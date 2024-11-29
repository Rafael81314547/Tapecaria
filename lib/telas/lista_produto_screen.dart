import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tapecaria/mensagens_modal/snackbar.dart';
import 'package:tapecaria/modelos/carrinho.dart';
import 'package:tapecaria/servicos/carrinho_service.dart';
import 'package:tapecaria/servicos/produto_service.dart';
import 'package:tapecaria/servicos/usuario_service.dart';
import 'package:tapecaria/modelos/produto.dart';

class ProductListScreen extends StatefulWidget {
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  ProdutoService produtoService = ProdutoService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          "Lista de Produtos",
          style: GoogleFonts.greatVibes(
            fontSize: 40.0,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder(
          stream: produtoService.todos(), // Obtenção dos produtos do Firebase
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Erro ao carregar produtos'));
            }

            if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
              return Center(child: Text('Nenhum produto encontrado.'));
            }

            var products = snapshot.data?.docs.map((doc) {
              return Produto.fromMap(doc.data() as Map<String, dynamic>);
            }).toList();

            return ListView.builder(
              itemCount: products?.length ?? 0,
              itemBuilder: (context, index) {
                var produto = products?[index];

                return ProductTile(
                  idProduct: produto?.id ?? '',
                  productName: produto?.nome ?? 'Produto sem nome',
                  productDescription: produto?.descricao ?? 'Sem descrição',
                  productPrice: produto?.preco ?? 0.0,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ProductTile extends StatefulWidget {
  final String idProduct;
  final String productName;
  final String productDescription;
  final double productPrice;

  const ProductTile({
    required this.idProduct,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
  });

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  CarrinhoService carrinhoService = CarrinhoService();
  UserService usuarioService = UserService();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
          widget.productName,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.brown,
          ),
        ),
        subtitle: Text(
          '${widget.productDescription}\nPreço: R\$ ${widget.productPrice.toStringAsFixed(2)}',
          style: const TextStyle(color: Colors.brown),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            User? usuario = usuarioService.getUserId();

            carrinhoService.criar(Carrinho(
                idUsuario: usuario?.uid ?? '',
                idProduto: widget.idProduct,
                quantidade: 1));

            showSnackBar(
                context: context,
                message: "Produto adicionado no carrinho!",
                isError: false);
          },
        ),
      ),
    );
  }
}
