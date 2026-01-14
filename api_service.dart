import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:buku_app/models/buku.dart';

class ApiService {
  static const String baseUrl =  "http://127.0.0.1:8000/api";

  // ================= AUTH =================

  static Future<bool> register(
      String name,
      String email,
      String password,
      ) async {
    final res = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      }),
    );

    print("REGISTER RESPONSE: ${res.body}");
    return res.statusCode == 200 || res.statusCode == 201;
  }

  static Future<bool> login(
      String email,
      String password,
      ) async {
    final res = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    print("LOGIN RESPONSE: ${res.body}");
    return res.statusCode == 200;
  }

  // ================= BUKU =================

  static Future<List<Buku>> getBuku() async {
    final res = await http.get(Uri.parse("$baseUrl/buku"));

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Buku.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil data buku");
    }
  }

  static Future<void> tambahBuku(
      String id,
      String judul,
      String pengarang,
      String penerbit,
      ) async {
    await http.post(
      Uri.parse("$baseUrl/buku"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "idbuku": id,
        "judul": judul,
        "pengarang": pengarang,
        "penerbit": penerbit,
      }),
    );
  }

  static Future<void> hapusBuku(String id) async {
    await http.delete(
      Uri.parse("$baseUrl/buku/$id"),
    );
  }
}
