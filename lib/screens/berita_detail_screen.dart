import 'package:flutter/material.dart';
import '../models/news_model.dart';

/// Halaman detail berita (soal nomor 5) — dibuka sebagai page baru ketika
/// user menekan salah satu item berita.
class BeritaDetailScreen extends StatelessWidget {
  final NewsModel news;
  const BeritaDetailScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: news.imageUrl != null
                  ? Hero(
                      tag: news.imageUrl!,
                      child: Image.network(
                        news.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFF4F46E5).withOpacity(0.15),
                        ),
                      ),
                    )
                  : Container(color: const Color(0xFF4F46E5).withOpacity(0.15)),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold, height: 1.3),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    children: [
                      if (news.source != null && news.source!.isNotEmpty)
                        _MetaChip(icon: Icons.source_outlined, label: news.source!),
                      if (news.publishedAt != null && news.publishedAt!.isNotEmpty)
                        _MetaChip(icon: Icons.calendar_today_outlined, label: news.publishedAt!),
                    ],
                  ),
                  const Divider(height: 32),
                  Text(
                    news.description,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    (news.content == null || news.content!.isEmpty)
                        ? news.description
                        : news.content!,
                    style: const TextStyle(fontSize: 14, height: 1.7, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF4F46E5).withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF4F46E5)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF4F46E5), fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
