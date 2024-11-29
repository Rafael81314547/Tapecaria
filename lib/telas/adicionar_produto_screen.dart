import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tapecaria/mensagens_modal/snackbar.dart';
import 'package:tapecaria/modelos/produto.dart';
import 'package:tapecaria/servicos/produto_service.dart';

class AddProductScreen extends StatefulWidget {
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController nomeController = TextEditingController();

  final TextEditingController descricaoController = TextEditingController();

  final TextEditingController valorController = TextEditingController();

  final _cadastroProdutoForm = GlobalKey<FormState>();
  final ProdutoService _produtoservice = ProdutoService();

  _salvarProduto() async {
    var nome = nomeController.text;
    var valor = valorController.text;
    var descricao = descricaoController.text;

    await _produtoservice
        .criar(Produto(
            nome: nome, descricao: descricao, preco: double.parse(valor)))
        .then((ocorreuErro) {
      if (ocorreuErro != null) {
        showSnackBar(context: context, message: ocorreuErro);
      } else {
        showSnackBar(
          context: context,
          message: "Cadastro do produto feito com sucesso!",
          isError: false,
        );
      }
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          "Cadastrar Produto",
          style: GoogleFonts.greatVibes(
            fontSize: 40.0,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _cadastroProdutoForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: const Text(
                    'Cadastro de Produto',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.app_registration,
                              size: 70, color: Colors.brown),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Nome do Produto',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: nomeController,
                        decoration: const InputDecoration(
                          hintText: 'Digite o nome do produto',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (String? value) {
                          if (value == '' || value == null) {
                            return "Preencha o campo";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Valor do Produto',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d*')),
                        ],
                        controller: valorController,
                        decoration: const InputDecoration(
                          hintText: 'Digite o valor do produto',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        maxLength: 7,
                        validator: (String? value) {
                          if (value == 0.00 || value == '') {
                            return "Forneça o valor";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Descrição do Produto',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: descricaoController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: 'Digite a descrição do produto',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (String? value) {
                          if (value == '' || value == null) {
                            return "Preencha o campo";
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: _salvarProduto,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Salvar',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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
