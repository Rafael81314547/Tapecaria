class Carrinho {
  late String? id;
  late String idUsuario;
  late String idProduto;
  late int quantidade;

  Carrinho(
      {String? id,
      required String idUsuario,
      required String idProduto,
      required int quantidade}) {
    this.id = id;
    this.idUsuario = idUsuario;
    this.idProduto = idProduto;
    this.quantidade = (quantidade != null) ? quantidade : 1;
  }

  factory Carrinho.fromMap(Map<String, dynamic> map) {
    return Carrinho(
      id: map['id'],
      idUsuario: map['idUsuario'],
      idProduto: map['idProduto'],
      quantidade: map['quantidade'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idUsuario': idUsuario,
      'idProduto': idProduto,
      'quantidade': quantidade
    };
  }
}
