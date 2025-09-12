import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import '../bloc/audio_bloc.dart';
import '../bloc/audio_event.dart';
import '../bloc/audio_state.dart';
import '../data/models/audio_model.dart';
import '../presentation/widgets/audio_player_manager.dart';

// État du lecteur audio
class AudioPlayerState {
  final AudioModel? currentAudio;
  final bool isPlaying;
  final Duration currentPosition;
  final Duration totalDuration;

  AudioPlayerState({
    this.currentAudio,
    this.isPlaying = false,
    this.currentPosition = Duration.zero,
    this.totalDuration = Duration.zero,
  });
}

class AudioPage extends StatefulWidget {
  const AudioPage({super.key});

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  AudioPlayerState playerState = AudioPlayerState();
  late AudioPlayerManager audioManager;

  @override
  void initState() {
    super.initState();
    audioManager = AudioPlayerManager();
    context.read<AudioBloc>().add(LoadAudiosEvent());

    // Écouter les changements du lecteur audio
    audioManager.player.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          playerState = AudioPlayerState(
            currentAudio: audioManager.currentAudio,
            isPlaying: state.playing,
            currentPosition: audioManager.player.position,
            totalDuration: audioManager.player.duration ?? Duration.zero,
          );
        });
      }
    });

    // Écouter les changements de position
    audioManager.player.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          playerState = AudioPlayerState(
            currentAudio: playerState.currentAudio,
            isPlaying: playerState.isPlaying,
            currentPosition: position,
            totalDuration: playerState.totalDuration,
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E2E),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1E2E),
        elevation: 0,
        title: Text(
          "Mes Livres Audio",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          Icon(Icons.search, color: Colors.white),
          SizedBox(width: 16),
          Icon(Icons.more_vert, color: Colors.white),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<AudioBloc, AudioState>(
              builder: (context, state) {
                if (state is AudioLoading) {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                } else if (state is AudioLoaded) {
                  if (state.audios.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.music_note, size: 80, color: Colors.grey),
                          SizedBox(height: 20),
                          Text(
                            'Aucun audio disponible',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    );
                  }
                  return _buildAudioList(state.audios);
                } else if (state is AudioError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Erreur: ${state.message}',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<AudioBloc>().add(LoadAudiosEvent()),
                          child: Text('Réessayer'),
                        ),
                      ],
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),

          if (playerState.currentAudio != null)
            AudioPlayerBottomBar(
              playerState: playerState,
              onPlayPause: _togglePlayPause,
              onNext: _playNext,
              onPrevious: _playPrevious,
              onClose: _closePlayer,
              onSeek: _seekTo,
            ),
        ],
      ),
    );
  }

  Widget _buildAudioList(List<AudioModel> audios) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8),
      itemCount: audios.length,
      itemBuilder: (context, index) {
        final audio = audios[index];
        final isCurrentlyPlaying =
            playerState.currentAudio?.id == audio.id && playerState.isPlaying;

        return AudioListItem(
          audio: audio,
          isPlaying: isCurrentlyPlaying,
          onTap: () => _onAudioTap(audio),
        );
      },
    );
  }

  void _onAudioTap(AudioModel audio) async {
    if (playerState.currentAudio?.id == audio.id) {
      if (playerState.isPlaying) {
        await audioManager.pause();
      } else {
        await audioManager.resume();
      }
    } else {
      await audioManager.playAudio(audio);
    }
  }

  void _togglePlayPause() async {
    if (playerState.isPlaying) {
      await audioManager.pause();
    } else {
      await audioManager.resume();
    }
  }

  void _closePlayer() async {
    await audioManager.stop();
    setState(() {
      playerState = AudioPlayerState();
    });
  }

  void _seekTo(Duration position) async {
    await audioManager.seek(position);
  }

  void _playNext() {
    print('Lecture suivante');
  }

  void _playPrevious() {
    print('Lecture précédente');
  }

  @override
  void dispose() {
    audioManager.dispose();
    super.dispose();
  }
}

// Widget pour chaque audio dans la liste
class AudioListItem extends StatelessWidget {
  final AudioModel audio;
  final bool isPlaying;
  final VoidCallback onTap;

  const AudioListItem({
    Key? key,
    required this.audio,
    required this.isPlaying,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isPlaying ? Color(0xFF2A2A3A) : Colors.transparent,
          border: isPlaying
              ? Border(left: BorderSide(color: Color(0xFF4A90E2), width: 3))
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.network(
                  audio.getImageUrl(),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[700],
                    child: Icon(Icons.music_note, color: Colors.grey, size: 30),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[700],
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    audio.titre,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${audio.artiste}${audio.album.isNotEmpty ? ' • ${audio.album}' : ''}",
                    style: TextStyle(color: Colors.grey[400], fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text(
                    _formatDate(audio.uploadedAt),
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  audio.getFormattedDuration(),
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
                SizedBox(height: 8),
                if (isPlaying)
                  Icon(Icons.volume_up, color: Color(0xFF4A90E2), size: 16)
                else
                  Icon(Icons.music_note, color: Colors.grey[500], size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Fév',
      'Mar',
      'Avr',
      'Mai',
      'Juin',
      'Juil',
      'Aoû',
      'Sep',
      'Oct',
      'Nov',
      'Déc',
    ];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }
}

// Lecteur audio en bas avec contrôles complets
class AudioPlayerBottomBar extends StatelessWidget {
  final AudioPlayerState playerState;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onClose;
  final Function(Duration) onSeek;

  const AudioPlayerBottomBar({
    Key? key,
    required this.playerState,
    required this.onPlayPause,
    required this.onNext,
    required this.onPrevious,
    required this.onClose,
    required this.onSeek,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audio = playerState.currentAudio!;

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF2A2A3A),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Barre de progression
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  _formatDuration(playerState.currentPosition),
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
                Expanded(
                  child: Slider(
                    value: playerState.totalDuration.inMilliseconds > 0
                        ? playerState.currentPosition.inMilliseconds /
                              playerState.totalDuration.inMilliseconds
                        : 0.0,
                    onChanged: (value) {
                      final newPosition = Duration(
                        milliseconds:
                            (value * playerState.totalDuration.inMilliseconds)
                                .round(),
                      );
                      onSeek(newPosition);
                    },
                    activeColor: Color(0xFF4A90E2),
                    inactiveColor: Colors.grey[600],
                  ),
                ),
                Text(
                  _formatDuration(playerState.totalDuration),
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),

          // Contrôles principaux
          Container(
            height: 80,
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  margin: EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      audio.getImageUrl(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[700],
                        child: Icon(Icons.music_note, color: Colors.grey),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        audio.titre,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        "${audio.artiste}${audio.album.isNotEmpty ? ' • ${audio.album}' : ''}",
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: onPrevious,
                      icon: Icon(Icons.skip_previous, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: onPlayPause,
                      icon: Icon(
                        playerState.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    IconButton(
                      onPressed: onNext,
                      icon: Icon(Icons.skip_next, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: onClose,
                      icon: Icon(Icons.close, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}";
  }
}
