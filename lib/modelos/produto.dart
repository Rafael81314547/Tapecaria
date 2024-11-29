class Produto {
  late String? id;
  late String nome;
  late String descricao;
  late double preco;

  Produto(
      {String? id,
      required String nome,
      required String descricao,
      required double preco}) {
    this.id = id;
    this.nome = nome;
    this.descricao = descricao;
    this.preco = preco;
  }

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
        id: map['id'],
        nome: map['nome'],
        descricao: map['descricao'],
        preco: map['preco']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome, 'descricao': descricao, 'preco': preco};
  }
}
