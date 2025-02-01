import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class CalmMusicPage extends StatefulWidget {
  @override
  _CalmMusicPageState createState() => _CalmMusicPageState();
}

class _CalmMusicPageState extends State<CalmMusicPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentPlaying;
  bool isPlaying = false;
  bool isLoading = false;

  final List<Map<String, String>> calmSounds = [
    {
      "title": "Gentle Rain",
      "url": "https://www.soundjay.com/nature/rain-01.mp3",
      "duration": "0:29",
      "category": "nature",
      "description": "Soothing rain sounds"
    },
    {
      "title": "Ocean Waves",
      "url": "https://www.soundjay.com/nature/ocean-wave-2.mp3",
      "duration": "0:33",
      "category": "nature",
      "description": "Relaxing ocean waves"
    },
    {
      "title": "Stream Water",
      "url": "https://www.soundjay.com/nature/sounds/stream-1.mp3",
      "duration": "0:31",
      "category": "nature",
      "description": "Flowing stream water"
    },
    {
      "title": "Wind in Trees",
      "url": "https://www.soundjay.com/nature/sounds/wind-1.mp3",
      "duration": "0:50",
      "category": "nature",
      "description": "Gentle wind blowing through trees"
    },
    {
      "title": "Calm Forest",
      "url": "https://www.soundjay.com/nature/sounds/forest-1.mp3",
      "duration": "0:32",
      "category": "nature",
      "description": "Calm forest sounds"
    },
    {
      "title": "Lake Water",
      "url": "https://www.soundjay.com/nature/sounds/lake-1.mp3",
      "duration": "0:31",
      "category": "nature",
      "description": "Still lake water"
    },
    {
      "title": "Birds Chirping",
      "url": "https://www.soundjay.com/nature/sounds/birds-1.mp3",
      "duration": "0:45",
      "category": "nature",
      "description": "Chirping birds in the morning"
    },
    {
      "title": "Soft Piano",
      "url": "https://www.soundjay.com/misc/sounds/piano-1.mp3",
      "duration": "1:00",
      "category": "music",
      "description": "Soft piano melodies"
    },
    {
      "title": "Meditation Bells",
      "url": "https://www.soundjay.com/misc/sounds/bell-1.mp3",
      "duration": "0:30",
      "category": "music",
      "description": "Calming meditation bells"
    },
  ];

  Future<void> _togglePlay(String url, String title) async {
    try {
      if (_currentPlaying == url && isPlaying) {
        await _audioPlayer.pause();
        setState(() {
          isPlaying = false;
        });
        return;
      }

      setState(() {
        isLoading = true;
        _currentPlaying =
            url; // Set current URL immediately to show loading state
      });

      if (_audioPlayer.playing) {
        await _audioPlayer.stop();
      }

      await _audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(url)),
        initialPosition: Duration.zero,
      );

      await _audioPlayer.play();

      setState(() {
        isPlaying = true;
      });
    } catch (e) {
      print('Error playing audio: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Error: Unable to play this track. Please try another.'),
          backgroundColor: Colors.red,
        ),
      );
      // Reset state if playback fails
      setState(() {
        if (_currentPlaying == url) {
          _currentPlaying = null;
          isPlaying = false;
        }
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        setState(() {
          isPlaying = false;
          _currentPlaying = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Calm Sounds"),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: calmSounds.length,
        itemBuilder: (context, index) {
          final sound = calmSounds[index];
          final bool isCurrentTrack = _currentPlaying == sound["url"];
          final bool isCurrentlyPlaying = isCurrentTrack && isPlaying;
          final bool isThisLoading = isCurrentTrack && isLoading;

          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isCurrentlyPlaying
                      ? Colors.blue
                      : Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  isCurrentlyPlaying ? Icons.music_note : Icons.play_arrow,
                  color: isCurrentlyPlaying ? Colors.white : Colors.blue,
                  size: 30,
                ),
              ),
              title: Text(
                sound["title"]!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isCurrentlyPlaying ? Colors.blue : Colors.black87,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${sound["category"]!.toUpperCase()} • ${sound["duration"]!}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    sound["description"]!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              trailing: SizedBox(
                width: 60,
                height: 60,
                child: isThisLoading
                    ? Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.blue,
                          ),
                        ),
                      )
                    : IconButton(
                        icon: Icon(
                          isCurrentlyPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          size: 50,
                        ),
                        color:
                            isCurrentlyPlaying ? Colors.blue : Colors.grey[700],
                        onPressed: () =>
                            _togglePlay(sound["url"]!, sound["title"]!),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
