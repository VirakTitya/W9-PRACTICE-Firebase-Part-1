import '../../model/artists/artist.dart';

class ArtistDto {
  static const String nameKey = 'name';
  static const String genreKey = 'genre';
  static const String imageUrlKey = 'imageUrl';

  static Artist fromJson(Map<String, dynamic> json, {required String id}) {
    assert(json[nameKey] is String);
    assert(json[genreKey] is String);
    assert(json[imageUrlKey] is String);

    return Artist(
      id: id,
      name: json[nameKey],
      genre: json[genreKey],
      imageUrl: json[imageUrlKey],
    );
  }

  Map<String, dynamic> toJson(Artist artist) {
    return {
      nameKey: artist.name,
      genreKey: artist.genre,
      imageUrlKey: artist.imageUrl,
    };
  }
}
