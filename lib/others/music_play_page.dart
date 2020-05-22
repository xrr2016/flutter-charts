import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MusicPlayPage extends StatefulWidget {
  @override
  _MusicPlayPageState createState() => _MusicPlayPageState();
}

class _MusicPlayPageState extends State<MusicPlayPage> {
  String feel = 'feel.mp3';
  AudioCache cache = AudioCache(prefix: 'music/');
  AudioPlayerState state = AudioPlayerState.STOPPED;
  AudioPlayer player;

  @override
  void initState() {
    super.initState();
    cache.load(feel);
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.pause),
                onPressed: () {
                  player.pause();
                },
              ),
              Text(state.toString()),
              IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: () async {
                  player = await cache.play(feel);
                  player.playerId = 'playerId';
                  player.onPlayerStateChanged.listen((AudioPlayerState s) {
                    setState(() {
                      print(s);
                      state = s;
                    });
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
