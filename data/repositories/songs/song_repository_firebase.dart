import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  static const String _firebaseHost =
      'w9-firebase-p1-default-rtdb.asia-southeast1.firebasedatabase.app';
  final Uri songsUri = Uri.https(_firebaseHost, '/songs.json');

  @override
  Future<List<Song>> fetchSongs() async {
    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {
      // Firebase returns songs as a map keyed by song id.
      final dynamic decoded = json.decode(response.body);
      if (decoded == null) {
        return [];
      }

      final Map<String, dynamic> songsJson = Map<String, dynamic>.from(decoded);
      return songsJson.entries
          .where((entry) => entry.value is Map)
          .map((entry) {
            final Map<String, dynamic> songJson =
                Map<String, dynamic>.from(entry.value as Map);
            return SongDto.fromJson(songJson, id: entry.key);
          })
          .toList();
    } else {
      throw Exception('Failed to load songs');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {
    final Uri songByIdUri = Uri.https(_firebaseHost, '/songs/$id.json');
    final http.Response response = await http.get(songByIdUri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load song with id $id');
    }

    final dynamic decoded = json.decode(response.body);
    if (decoded == null) {
      return null;
    }

    final Map<String, dynamic> songJson = Map<String, dynamic>.from(decoded);
    return SongDto.fromJson(songJson, id: id);
  }
}
