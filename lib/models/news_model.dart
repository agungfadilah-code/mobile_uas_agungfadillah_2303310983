class NewsModel {
  final String title;
  final String description;
  final String? imageUrl;
  final String? source;
  final String? publishedAt;
  final String? content;
  final String? url;

  NewsModel({
    required this.title,
    required this.description,
    this.imageUrl,
    this.source,
    this.publishedAt,
    this.content,
    this.url,
  });

  /// Flexible factory: tries several common API response shapes so the app
  /// keeps working even if the field names differ slightly between APIs.
  factory NewsModel.fromJson(Map<String, dynamic> json) {
    String pick(List<String> keys, {String fallback = ''}) {
      for (final k in keys) {
        final v = json[k];
        if (v != null && v.toString().trim().isNotEmpty) {
          return v.toString();
        }
      }
      return fallback;
    }

    // image can sometimes be nested, e.g. { "urlToImage": ... } or { "image": { "url": ... } }
    String? image;
    final rawImage = json['urlToImage'] ?? json['image'] ?? json['thumbnail'] ?? json['img'];
    if (rawImage is String) {
      image = rawImage;
    } else if (rawImage is Map) {
      image = rawImage['url']?.toString();
    }

    return NewsModel(
      title: pick(['title', 'headline', 'name'], fallback: 'Tanpa Judul'),
      description: pick(['description', 'summary', 'desc'], fallback: 'Tidak ada deskripsi.'),
      imageUrl: image,
      source: pick(['source', 'author', 'publisher']),
      publishedAt: pick(['publishedAt', 'published_at', 'date']),
      content: pick(['content', 'body', 'text']),
      url: pick(['url', 'link']),
    );
  }
}
