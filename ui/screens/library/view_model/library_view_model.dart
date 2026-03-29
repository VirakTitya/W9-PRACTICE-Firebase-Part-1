import 'package:flutter/material.dart';
import '../../../../data/repositories/artists/artist_repository.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../../model/artists/artist.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';
import '../../../../model/songs/song_with_artist.dart';
import '../../../utils/async_value.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final ArtistRepository artistRepository;
  final PlayerState playerState;

  AsyncValue<List<SongWithArtist>> songsValue = AsyncValue.loading();

  LibraryViewModel({
    required this.songRepository,
    required this.artistRepository,
    required this.playerState,
  }) {
    playerState.addListener(notifyListeners);

    // init
    _init();
  }

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void _init() async {
    fetchSong();
  }

  void fetchSong() async {
    // 1- Loading state
    songsValue = AsyncValue.loading();
    notifyListeners();

    try {
      final List<dynamic> results = await Future.wait<dynamic>([
        songRepository.fetchSongs(),
        artistRepository.fetchArtists(),
      ]);

      final List<Song> songs = results[0] as List<Song>;
      final List<Artist> artists = results[1] as List<Artist>;

      final Map<String, Artist> artistsById = {
        for (final Artist artist in artists) artist.id: artist,
      };

      final List<SongWithArtist> songsWithArtist = songs
          .map(
            (song) => SongWithArtist(
              song: song,
              artist: artistsById[song.artistId],
            ),
          )
          .toList();

      songsValue = AsyncValue.success(songsWithArtist);
    } catch (e) {
      // 3- Fetch is unsucessfull
      songsValue = AsyncValue.error(e);
    }
     notifyListeners();

  }

  bool isSongPlaying(Song song) => playerState.currentSong == song;

  void start(Song song) => playerState.start(song);
  void stop(Song song) => playerState.stop();
}
