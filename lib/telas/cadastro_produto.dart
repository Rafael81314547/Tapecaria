import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tapecaria/servicos/produto_service.dart';
import 'package:tapecaria/telas/adicionar_produto_screen.dart';
import 'package:tapecaria/modelos/produto.dart';

class ProductCreateScreen extends StatefulWidget {
  @override
  State<ProductCreateScreen> createState() => _ProductCreateScreenState();
}

class _ProductCreateScreenState extends State<ProductCreateScreen> {
  ProdutoService produtoService = ProdutoService();
  void _delete(String id) {
    produtoService.deletar(id);
  }

  void _editProduct(BuildContext context, Produto produto) {
    TextEditingController nomeController =
        TextEditingController(text: produto.nome);
    TextEditingController descricaoController =
        TextEditingController(text: produto.descricao);
    TextEditingController precoController =
        TextEditingController(text: produto.preco.toString());

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Editar Produto',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome do Produto'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descricaoController,
                decoration:
                    const InputDecoration(labelText: 'Descrição do Produto'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: precoController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Preço'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  Produto updatedProduct = Produto(
                    id: produto.id,
                    nome: nomeController.text,
                    descricao: descricaoController.text,
                    preco: double.parse(precoController.text),
                  );

                  await produtoService.alterar(updatedProduct);

                  Navigator.pop(context);
                },
                child: const Text('Alterar',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          "Gerenciar Produtos",
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
                  productName: produto?.nome ?? 'Produto sem nome',
                  productDescription: produto?.descricao ?? 'Sem descrição',
                  productPrice: produto?.preco ?? 0.0,
                  onEdit: () => _editProduct(context, produto!),
                  onDelete: () {
                    _delete(produto?.id ?? '');
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductScreen()),
          );
        },
        backgroundColor: Colors.brown,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  final String productName;
  final String productDescription;
  final double productPrice;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductTile({
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.onEdit,
    required this.onDelete,
  });

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
          productName,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.brown,
          ),
        ),
        subtitle: Text(
          '$productDescription\nPreço: R\$ ${productPrice.toStringAsFixed(2)}',
          style: const TextStyle(color: Colors.brown),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
