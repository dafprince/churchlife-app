import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/audios/presentation/audio_page.dart';
import 'package:mobile/features/audios/presentation/widgets/AudioListItemPro.dart';
import '../../audios/bloc/audio_bloc.dart';
import '../../audios/bloc/audio_event.dart';
import '../../audios/bloc/audio_state.dart';
import '../../audios/data/models/audio_model.dart';
import '../../audios/presentation/widgets/audio_player_manager.dart'; // Ton widget d’affichage audio

class EgliseDetailScreen extends StatefulWidget {
  final String id;
  final String nom;
  final String imageUrl;
  //===============modife
  const EgliseDetailScreen({
    Key? key,
    required this.id,
    required this.nom,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<EgliseDetailScreen> createState() => _EgliseDetailScreenState();
}

class _EgliseDetailScreenState extends State<EgliseDetailScreen> {
  AudioPlayerManager audioManager =
      AudioPlayerManager(); // Ton gestionnaire audio
  AudioPlayerState playerState = AudioPlayerState();

  @override
  void initState() {
    super.initState();
    // Charge les audios liés à cette église
    context.read<AudioBloc>().add(LoadAudiosByEgliseEvent(widget.id));

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
  void dispose() {
    audioManager.reset(); // Reset audio à la sortie de page
    super.dispose();
  }

  void _togglePlayPause() {
    if (playerState.isPlaying) {
      audioManager.pause();
    } else {
      audioManager.resume();
    }
  }

  void _closePlayer() {
    audioManager.stop();
    setState(() {
      playerState = AudioPlayerState();
    });
  }

  void _playAudio(AudioModel audio) async {
    // Implement your audio playing logic
    await audioManager.playAudio(audio);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 250,
            backgroundColor: const Color(0xFF87CEEB),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.nom,
                style: const TextStyle(color: Colors.white),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(widget.imageUrl, fit: BoxFit.cover),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black54],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
            ),
          ),

          BlocBuilder<AudioBloc, AudioState>(
            builder: (context, state) {
              if (state is AudioLoading) {
                return SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (state is AudioError) {
                return SliverFillRemaining(
                  child: Center(child: Text('Erreur: ${state.message}')),
                );
              }
              if (state is AudioLoaded) {
                if (state.audios.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text("Aucune prédication disponible."),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final audio = state.audios[index];
                    final isPlaying =
                        playerState.currentAudio?.id == audio.id &&
                        playerState.isPlaying;

                    return AudioListItemPro(
                      audio: audio,
                      isPlaying: isPlaying,
                      onTap: () => _playAudio(audio),
                    );
                  }, childCount: state.audios.length),
                );
              }

              return SliverFillRemaining(child: SizedBox.shrink());
            },
          ),

          // Ajouter un espace de padding en fin de liste pour l'audio player bar
          SliverPadding(padding: EdgeInsets.only(bottom: 80)),
        ],
      ),

      // Player bar fixe en bas si un audio est chargé
      bottomNavigationBar: playerState.currentAudio != null
          ? AudioPlayerBottomBar(
              playerState: playerState,
              onPlayPause: _togglePlayPause,
              onClose: _closePlayer,
              onNext: () {}, // facultatif
              onPrevious: () {}, // facultatif
              onSeek: (pos) => audioManager.seek(pos),
            )
          : SizedBox.shrink(),
    );
  }
}
