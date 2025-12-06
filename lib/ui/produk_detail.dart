import 'package:flutter/material.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_form.dart';
import 'package:tokokita/ui/produk_page.dart';
import 'package:tokokita/widget/warning_dialog.dart';

// ignore: must_be_immutable
class ProdukDetail extends StatefulWidget {
  Produk? produk;
  ProdukDetail({Key? key, this.produk}) : super(key: key);

  @override
  _ProdukDetailState createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Inventaris Tsaqifmart')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Icon barang
              // Container(
              //   width: 100,
              //   height: 100,
              //   decoration: BoxDecoration(
              //     color: Colors.grey[300],
              //     borderRadius: BorderRadius.circular(20),
              //   ),
              //   child: Icon(
              //     Icons.inventory_2,
              //     color: Colors.grey[700],
              //     size: 50,
              //   ),
              // ),
              // const SizedBox(height: 24),
              // Card detail informasi
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        icon: Icons.qr_code,
                        label: "Kode Barang",
                        value: widget.produk!.kodeProduk!,
                      ),
                      const Divider(height: 24),
                      _buildDetailRow(
                        icon: Icons.label,
                        label: "Nama Barang",
                        value: widget.produk!.namaProduk!,
                      ),
                      const Divider(height: 24),
                      _buildDetailRow(
                        icon: Icons.attach_money,
                        label: "Harga",
                        value: "Rp ${widget.produk!.hargaProduk.toString()}",
                      ),
                      const Divider(height: 24),
                      _buildDetailRow(
                        icon: Icons.inventory,
                        label: "Jumlah Stok",
                        value: widget.produk!.jumlahProduk.toString(),
                      ),
                      const Divider(height: 24),
                      _buildDetailRow(
                        icon: Icons.calendar_today,
                        label: "Tanggal Masuk",
                        value: _formatDateTime(widget.produk!.createdAt),
                      ),
                      const Divider(height: 24),
                      _buildDetailRow(
                        icon: Icons.update,
                        label: "Terakhir Diupdate",
                        value: _formatDateTime(widget.produk!.updatedAt),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _tombolHapusEdit(),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) {
      return "-";
    }
    try {
      DateTime dateTime = DateTime.parse(dateTimeStr);
      String day = dateTime.day.toString().padLeft(2, '0');
      String month = dateTime.month.toString().padLeft(2, '0');
      String year = dateTime.year.toString();
      String hour = dateTime.hour.toString().padLeft(2, '0');
      String minute = dateTime.minute.toString().padLeft(2, '0');
      return "$day/$month/$year $hour:$minute";
    } catch (e) {
      return dateTimeStr;
    }
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.grey[700], size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      children: [
        // Tombol Edit
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.edit),
            label: const Text("EDIT"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProdukForm(produk: widget.produk!),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        // Tombol Hapus
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.delete, color: Colors.red),
            label: const Text("DELETE", style: TextStyle(color: Colors.red)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => confirmHapus(),
          ),
        ),
      ],
    );
  }

  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      content: const Text("Yakin ingin menghapus data ini?"),
      actions: [
        //tombol hapus
        OutlinedButton(
          child: const Text("Ya"),
          onPressed: () {
            ProdukBloc.deleteProduk(id: int.parse(widget.produk!.id!)).then(
              (value) => {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ProdukPage()),
                ),
              },
              onError: (error) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => const WarningDialog(
                    description: "Hapus gagal, silahkan coba lagi",
                  ),
                );
              },
            );
          },
        ),
        //tombol batal
        OutlinedButton(
          child: const Text("Batal"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
    showDialog(builder: (context) => alertDialog, context: context);
  }
}
