import 'package:flutter/material.dart';

import '../../../model/songs/song_with_artist.dart';

class SongTile extends StatelessWidget {
  const SongTile({
    super.key,
    required this.songWithArtist,
    required this.isPlaying,
    required this.onTap,
  });

  final SongWithArtist songWithArtist;
  final bool isPlaying;
  final VoidCallback onTap;

  String get artistInfoLabel => songWithArtist.artistLabel;

  String get durationLabel {
    final int minutes = (songWithArtist.song.duration.inSeconds / 60).round();
    return '$minutes mins';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)
        ),
        child: ListTile(
          onTap: onTap,
          leading: CircleAvatar(
            backgroundImage: NetworkImage(songWithArtist.song.imageUrl),
          ),
          title: Text(songWithArtist.song.title),
          subtitle: Text('$durationLabel   $artistInfoLabel'),
          trailing: Text(
            isPlaying ? "Playing" : "",
            style: TextStyle(color: Colors.amber),
          ),
        ),
      ),
    );
  }
}
