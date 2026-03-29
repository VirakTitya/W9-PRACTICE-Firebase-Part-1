import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/artists/artist.dart';
import '../../dtos/artist_dto.dart';
import 'artist_repository.dart';

class ArtistRepositoryFirebase extends ArtistRepository {
  static const String _firebaseHost =
      'w9-firebase-p1-default-rtdb.asia-southeast1.firebasedatabase.app';

  final Uri artistsUri = Uri.https(_firebaseHost, '/artists.json');

  @override
  Future<List<Artist>> fetchArtists() async {
    final http.Response response = await http.get(artistsUri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load artists');
    }

    final dynamic decoded = json.decode(response.body);
    if (decoded == null) {
      return [];
    }

    final Map<String, dynamic> artistsJson = Map<String, dynamic>.from(decoded);
    return artistsJson.entries
        .where((entry) => entry.value is Map)
        .map((entry) {
          final Map<String, dynamic> artistJson =
              Map<String, dynamic>.from(entry.value as Map);
          return ArtistDto.fromJson(artistJson, id: entry.key);
        })
        .toList();
  }

  @override
  Future<Artist?> fetchArtistById(String id) async {
    final Uri artistByIdUri = Uri.https(_firebaseHost, '/artists/$id.json');
    final http.Response response = await http.get(artistByIdUri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load artist with id $id');
    }

    final dynamic decoded = json.decode(response.body);
    if (decoded == null) {
      return null;
    }

    final Map<String, dynamic> artistJson = Map<String, dynamic>.from(decoded);
    return ArtistDto.fromJson(artistJson, id: id);
  }
}
