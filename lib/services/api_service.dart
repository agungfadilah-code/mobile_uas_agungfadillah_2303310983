import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';
import '../models/movie_model.dart';

/// Central place for all network calls used in the app.
///
/// The exam only provides one API endpoint:
///   https://fakenews.squirro.com/news/sport
/// That endpoint is used both for the "Berita" (news) feature and for the
/// "movies_list.dart" feature required in soal nomor 6.
///
/// Because the exact JSON shape of that endpoint can vary / be unreachable
/// (e.g. no internet during grading), every fetch method below falls back to
/// realistic dummy data so the UI can still be demonstrated end-to-end.
class ApiService {
  static const String newsApiUrl = 'https://fakenews.squirro.com/news/sport';

  /// Tries to find a list inside common response shapes:
  /// - a raw JSON array
  /// - { "articles": [...] }
  /// - { "data": [...] }
  /// - { "results": [...] }
  /// - { "items": [...] }
  static List<dynamic> _extractList(dynamic decoded) {
    if (decoded is List) return decoded;
    if (decoded is Map) {
      for (final key in ['articles', 'data', 'results', 'items', 'news', 'movies']) {
        final v = decoded[key];
        if (v is List) return v;
      }
    }
    return [];
  }

  static Future<List<NewsModel>> fetchNews({int? limit}) async {
    try {
      final response = await http
          .get(Uri.parse(newsApiUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final list = _extractList(decoded);
        if (list.isNotEmpty) {
          final news = list
              .whereType<Map<String, dynamic>>()
              .map((e) => NewsModel.fromJson(e))
              .toList();
          if (news.isNotEmpty) {
            return limit != null ? news.take(limit).toList() : news;
          }
        }
      }
      throw Exception('Data API kosong / format tidak dikenali');
    } catch (e) {
      // Fallback ke data dummy supaya UI tetap bisa didemokan
      final dummy = _dummyNews();
      return limit != null ? dummy.take(limit).toList() : dummy;
    }
  }

  static Future<List<MovieModel>> fetchMovies({int? limit}) async {
    try {
      final response = await http
          .get(Uri.parse(newsApiUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final list = _extractList(decoded);
        if (list.isNotEmpty) {
          final movies = list
              .whereType<Map<String, dynamic>>()
              .map((e) => MovieModel.fromJson(e))
              .toList();
          if (movies.isNotEmpty) {
            return limit != null ? movies.take(limit).toList() : movies;
          }
        }
      }
      throw Exception('Data API kosong / format tidak dikenali');
    } catch (e) {
      final dummy = _dummyMovies();
      return limit != null ? dummy.take(limit).toList() : dummy;
    }
  }

  static List<NewsModel> _dummyNews() {
    return [
      NewsModel(
        title: 'Timnas Indonesia Menang Telak di Laga Persahabatan',
        description:
            'Timnas Indonesia berhasil mengalahkan lawannya dengan skor telak dalam laga uji coba menjelang turnamen resmi.',
        imageUrl: 'https://picsum.photos/seed/sport1/600/400',
        source: 'Sport News',
        publishedAt: '2026-07-08',
        content:
            'Pertandingan berlangsung sengit sejak menit awal. Pelatih menerapkan strategi menyerang yang efektif sehingga tim mampu mencetak gol lebih awal. Suporter yang memadati stadion terus memberikan dukungan hingga peluit panjang dibunyikan.',
      ),
      NewsModel(
        title: 'Liga Basket Nasional Musim Ini Diprediksi Lebih Ketat',
        description:
            'Sejumlah tim baru bergabung membuat persaingan musim ini diprediksi jauh lebih ketat dibanding musim sebelumnya.',
        imageUrl: 'https://picsum.photos/seed/sport2/600/400',
        source: 'Sport News',
        publishedAt: '2026-07-07',
        content:
            'Analis olahraga menilai kedatangan pemain-pemain muda berbakat akan mengubah peta kekuatan liga. Beberapa tim papan atas musim lalu bahkan disebut harus bekerja ekstra keras untuk mempertahankan posisi mereka.',
      ),
      NewsModel(
        title: 'Atlet Bulu Tangkis Muda Raih Juara di Turnamen Internasional',
        description:
            'Seorang atlet muda berhasil mengharumkan nama bangsa dengan meraih gelar juara di turnamen internasional.',
        imageUrl: 'https://picsum.photos/seed/sport3/600/400',
        source: 'Sport News',
        publishedAt: '2026-07-06',
        content:
            'Perjuangannya di final berlangsung alot hingga rubber game. Dengan mental juara, ia mampu membalikkan keadaan setelah tertinggal di gim kedua dan akhirnya menutup laga dengan kemenangan meyakinkan.',
      ),
      NewsModel(
        title: 'Klub Sepak Bola Lokal Umumkan Pemain Baru',
        description:
            'Klub kebanggaan daerah resmi memperkenalkan tiga pemain baru untuk memperkuat skuad musim depan.',
        imageUrl: 'https://picsum.photos/seed/sport4/600/400',
        source: 'Sport News',
        publishedAt: '2026-07-05',
        content:
            'Manajemen klub optimis kehadiran pemain baru dapat meningkatkan daya saing tim di kompetisi musim depan. Ketiga pemain tersebut sudah menjalani sesi latihan perdana bersama tim.',
      ),
      NewsModel(
        title: 'Marathon Kota Digelar dengan Ribuan Peserta',
        description:
            'Event lari marathon tahunan sukses digelar dan diikuti ribuan peserta dari berbagai daerah.',
        imageUrl: 'https://picsum.photos/seed/sport5/600/400',
        source: 'Sport News',
        publishedAt: '2026-07-04',
        content:
            'Rute sepanjang 42 kilometer ini melewati sejumlah landmark ikonik kota. Panitia menyediakan pos kesehatan di sepanjang rute untuk memastikan keselamatan para pelari.',
      ),
      NewsModel(
        title: 'Cabang Olahraga Renang Cetak Rekor Baru',
        description:
            'Perenang nasional berhasil memecahkan rekor nasional pada nomor 100 meter gaya bebas.',
        imageUrl: 'https://picsum.photos/seed/sport6/600/400',
        source: 'Sport News',
        publishedAt: '2026-07-03',
        content:
            'Catatan waktu terbaru ini menjadi modal berharga menjelang kejuaraan tingkat regional. Pelatih menyebut program latihan intensif menjadi kunci pencapaian tersebut.',
      ),
    ];
  }

  static List<MovieModel> _dummyMovies() {
    return [
      MovieModel(
        title: 'Petualangan di Ujung Dunia',
        overview:
            'Sekelompok penjelajah menempuh perjalanan berbahaya untuk menemukan harta karun yang hilang.',
        posterUrl: 'https://picsum.photos/seed/movie1/400/600',
        releaseDate: '2026-01-12',
        rating: 8.1,
      ),
      MovieModel(
        title: 'Bayang Kota Malam',
        overview:
            'Seorang detektif mengungkap konspirasi besar yang tersembunyi di balik gemerlap kota.',
        posterUrl: 'https://picsum.photos/seed/movie2/400/600',
        releaseDate: '2026-02-20',
        rating: 7.6,
      ),
      MovieModel(
        title: 'Langkah Terakhir',
        overview:
            'Kisah inspiratif seorang atlet yang bangkit dari keterpurukan untuk meraih mimpi.',
        posterUrl: 'https://picsum.photos/seed/movie3/400/600',
        releaseDate: '2026-03-15',
        rating: 8.4,
      ),
      MovieModel(
        title: 'Rahasia Pulau Terpencil',
        overview:
            'Sekelompok remaja terdampar di pulau misterius yang menyimpan rahasia kelam.',
        posterUrl: 'https://picsum.photos/seed/movie4/400/600',
        releaseDate: '2026-04-02',
        rating: 7.2,
      ),
      MovieModel(
        title: 'Cinta di Musim Hujan',
        overview:
            'Kisah romansa dua insan yang dipertemukan kembali setelah bertahun-tahun berpisah.',
        posterUrl: 'https://picsum.photos/seed/movie5/400/600',
        releaseDate: '2026-05-18',
        rating: 7.9,
      ),
    ];
  }
}
