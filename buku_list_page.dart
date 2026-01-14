import 'package:flutter/material.dart';
import 'package:buku_app/models/buku.dart';
import 'package:buku_app/services/api_service.dart';
import 'tambah_buku_page.dart';

class BukuListPage extends StatefulWidget {
  const BukuListPage({super.key});

  @override
  State<BukuListPage> createState() => _BukuListPageState();
}

class _BukuListPageState extends State<BukuListPage> {
  late Future<List<Buku>> data;

  @override
  void initState() {
    super.initState();
    data = ApiService.getBuku();
  }

  void refresh() {
    setState(() {
      data = ApiService.getBuku();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Buku"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TambahBukuPage()),
          );
          refresh();
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Buku>>(
        future: data,
        builder: (context, snapshot) {
          // LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ERROR
          if (snapshot.hasError) {
            return const Center(
              child: Text("Gagal memuat data buku"),
            );
          }

          // DATA KOSONG
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.menu_book,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Belum ada data buku",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Silakan tambahkan data buku terlebih dahulu",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // DATA ADA
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final buku = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  leading: const Icon(Icons.book),
                  title: Text(buku.judul),
                  subtitle: Text(
                    "${buku.pengarang} • ${buku.penerbit}",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await ApiService.hapusBuku(buku.idbuku);
                      refresh();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
