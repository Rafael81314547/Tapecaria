import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tapecaria/modelos/carrinho.dart';
import 'package:tapecaria/modelos/produto.dart';
import 'package:tapecaria/servicos/produto_service.dart';

class CarrinhoService {
  final CollectionReference firebaseCarrinho =
      FirebaseFirestore.instance.collection('carrinhos');

  final ProdutoService produtoService = ProdutoService();

  Future<String?> criar(Carrinho carrinho) async {
    try {
      DocumentReference carrinhoAdicionado =
          await firebaseCarrinho.add(carrinho.toMap());

      await carrinhoAdicionado.update({'id': carrinhoAdicionado.id});

      return null;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Future<List<Produto>> todos(String idUsuario) async {
    try {
      var querySnapshot =
          await firebaseCarrinho.where('idUsuario', isEqualTo: idUsuario).get();

      var products = await Future.wait(querySnapshot.docs.map((doc) async {
        var data = doc.data() as Map<String, dynamic>;
        var idProduto = data['idProduto'];

        var produtoDoc = await produtoService.buscaPeloId(idProduto);

        if (produtoDoc.docs.isNotEmpty) {
          var produtoData =
              produtoDoc.docs.first.data() as Map<String, dynamic>;
          return Produto.fromMap(produtoData);
        } else {
          return Produto(
              id: '',
              nome: 'Produto não encontrado',
              descricao: '',
              preco: 0.0);
        }
      }).toList());

      return products;
    } catch (e) {
      throw Exception('Erro ao buscar produtos no carrinho: $e');
    }
  }

  deletar(String id) async {
    await firebaseCarrinho.doc(id).delete();
  }

  Future<void> deletarL(
      {required String idProduto, required String idUsuario}) async {
    try {
      var querySnapshot = await firebaseCarrinho
          .where('idProduto', isEqualTo: idProduto)
          .where('idUsuario', isEqualTo: idUsuario)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print("Erro ao deletar documentos: $e");
    }
  }
}
