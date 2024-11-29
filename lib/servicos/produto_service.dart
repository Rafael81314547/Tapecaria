import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tapecaria/modelos/produto.dart';

class ProdutoService {
  final CollectionReference firebaseProduto =
      FirebaseFirestore.instance.collection('produtos');

  Future<String?> criar(Produto produto) async {
    try {
      DocumentReference produtoAdicionado =
          await firebaseProduto.add(produto.toMap());

      await produtoAdicionado.update({'id': produtoAdicionado.id});

      return null;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Future<QuerySnapshot> buscaPeloId(String id) async {
    return firebaseProduto.where('id', isEqualTo: id).get();
  }

  Stream<QuerySnapshot> todos() {
    return firebaseProduto.snapshots();
  }

  Future<String?> alterar(Produto produto) async {
    try {
      await firebaseProduto.doc(produto.id).update({
        'nome': produto.nome,
        'descricao': produto.descricao,
        'preco': produto.preco
      });

      return null;
    } on FirebaseException catch (e) {
      return 'Erro ao atualizar dados: ${e.message}';
    }
  }

  Future<void> deletar(String id) async {
    await firebaseProduto.doc(id).delete();
  }
}
