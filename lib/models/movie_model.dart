class MovieModel {
  final String title;
  final String overview;
  final String? posterUrl;
  final String? releaseDate;
  final double? rating;

  MovieModel({
    required this.title,
    required this.overview,
    this.posterUrl,
    this.releaseDate,
    this.rating,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    String pick(List<String> keys, {String fallback = ''}) {
      for (final k in keys) {
        final v = json[k];
        if (v != null && v.toString().trim().isNotEmpty) {
          return v.toString();
        }
      }
      return fallback;
    }

    String? poster;
    final rawImage = json['poster'] ?? json['poster_path'] ?? json['image'] ?? json['thumbnail'];
    if (rawImage is String) poster = rawImage;

    double? rating;
    final rawRating = json['rating'] ?? json['vote_average'] ?? json['score'];
    if (rawRating != null) {
      rating = double.tryParse(rawRating.toString());
    }

    return MovieModel(
      title: pick(['title', 'name'], fallback: 'Tanpa Judul'),
      overview: pick(['overview', 'description', 'summary'], fallback: 'Tidak ada deskripsi.'),
      posterUrl: poster,
      releaseDate: pick(['release_date', 'releaseDate', 'date']),
      rating: rating,
    );
  }
}
