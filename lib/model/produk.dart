class Produk {
  String? id;
  String? kodeProduk;
  String? namaProduk;
  var hargaProduk;
  var jumlahProduk;
  String? createdAt;
  String? updatedAt;

  Produk({
    this.id,
    this.kodeProduk,
    this.namaProduk,
    this.hargaProduk,
    this.jumlahProduk,
    this.createdAt,
    this.updatedAt,
  });

  factory Produk.fromJson(Map<String, dynamic> obj) {
    return Produk(
      id: obj['id'],
      kodeProduk: obj['kode_produk'],
      namaProduk: obj['nama_produk'],
      hargaProduk: obj['harga'],
      jumlahProduk: obj['jumlah'],
      createdAt: obj['created_at'],
      updatedAt: obj['updated_at'],
    );
  }
}
