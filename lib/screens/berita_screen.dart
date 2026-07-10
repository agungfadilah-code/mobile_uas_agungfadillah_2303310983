import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../services/api_service.dart';
import 'berita_detail_screen.dart';

/// Halaman Berita: menampilkan seluruh data berita yang diambil dari API
/// (soal nomor 4). Setiap item bisa ditekan untuk melihat detail berita
/// (soal nomor 5).
class BeritaScreen extends StatefulWidget {
  const BeritaScreen({super.key});

  @override
  State<BeritaScreen> createState() => _BeritaScreenState();
}

class _BeritaScreenState extends State<BeritaScreen> {
  late Future<List<NewsModel>> _futureNews;

  @override
  void initState() {
    super.initState();
    _futureNews = ApiService.fetchNews();
  }

  Future<void> _refresh() async {
    setState(() {
      _futureNews = ApiService.fetchNews();
    });
    await _futureNews;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<List<NewsModel>>(
        future: _futureNews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final news = snapshot.data ?? [];

          if (news.isEmpty) {
            return ListView(
              children: const [
                SizedBox(height: 120),
                Icon(Icons.article_outlined, size: 56, color: Colors.grey),
                SizedBox(height: 12),
                Center(child: Text('Belum ada data berita.')),
              ],
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: news.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final item = news[index];
              return _BeritaListTile(news: item);
            },
          );
        },
      ),
    );
  }
}

class _BeritaListTile extends StatelessWidget {
  final NewsModel news;
  const _BeritaListTile({required this.news});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BeritaDetailScreen(news: news)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 8,
              child: news.imageUrl != null
                  ? Image.network(
                      news.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    news.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      if (news.source != null && news.source!.isNotEmpty) ...[
                        const Icon(Icons.source_outlined, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          news.source!,
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        const SizedBox(width: 12),
                      ],
                      if (news.publishedAt != null && news.publishedAt!.isNotEmpty) ...[
                        const Icon(Icons.calendar_today_outlined, size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          news.publishedAt!,
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                      const Spacer(),
                      const Text(
                        'Baca selengkapnya',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF4F46E5),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFF4F46E5).withOpacity(0.1),
      child: const Icon(Icons.image_outlined, color: Color(0xFF4F46E5), size: 40),
    );
  }
}
