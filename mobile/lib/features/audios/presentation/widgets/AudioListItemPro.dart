// Ajoute ceci dans ton fichier widgets/audio_list_item.dart par exemple
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/features/audios/data/models/audio_model.dart';

class AudioListItemPro extends StatelessWidget {
  final AudioModel audio;
  final bool isPlaying;
  final VoidCallback onTap;

  const AudioListItemPro({
    super.key,
    required this.audio,
    required this.isPlaying,
    required this.onTap,
  });

  String formatFullDate(DateTime date) {
    // Exemple : "Dimanche 21 Octobre 2021"
    final weekDays = [
      'Dimanche',
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
    ];
    final months = [
      '',
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre',
    ];
    final wd = weekDays[date.weekday % 7];
    final day = date.day;
    final month = months[date.month];
    final year = date.year;
    return "$wd $day $month $year";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(32),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isPlaying
                  ? [Color(0xFF9CF0FC), Color(0xFF86A8F8)]
                  : [Color(0xFFF9FBFF), Color(0xFFE6ECFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: isPlaying ? Color(0x44667eea) : Colors.grey.shade100,
                blurRadius: isPlaying ? 22 : 10,
                offset: Offset(0, 8),
              ),
            ],
            border: isPlaying
                ? Border.all(color: Color(0xFF667eea), width: 3)
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image large avec bouton play
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                    child: Image.network(
                      audio.getImageUrl(),
                      height: 170,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => Container(
                        height: 170,
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.music_note,
                          size: 64,
                          color: Colors.grey,
                        ),
                      ),
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          height: 170,
                          color: Colors.grey[100],
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                    ),
                  ),
                  // Play bouton avec effet vitre/flottant
                  Positioned(
                    bottom: 14,
                    right: 20,
                    child: Material(
                      color: Colors.white.withOpacity(0.8),
                      shape: CircleBorder(),
                      elevation: 6,
                      child: InkWell(
                        customBorder: CircleBorder(),
                        onTap: onTap,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(
                            isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_fill,
                            size: 44,
                            color: Color(0xFF667eea),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Visualizer s’il joue
                  if (isPlaying)
                    Positioned(
                      left: 20,
                      bottom: 20,
                      top: 20,
                      child: Container(width: 7, child: _VisualizerBar()),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Thème : ${audio.titre}", // Thème
                      style: TextStyle(
                        color: Color(0xFF1D2236),
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        letterSpacing: 0.1,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Prédicateur : ${audio.artiste}",
                      style: TextStyle(
                        color: Color(0xFF2C3A5E),
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 0.2,
                      ),
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 16,
                          color: Colors.grey[500],
                        ),
                        SizedBox(width: 6),
                        Text(
                          formatFullDate(audio.uploadedAt),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget simple visuel du "visualizer"
class _VisualizerBar extends StatefulWidget {
  @override
  State<_VisualizerBar> createState() => _VisualizerBarState();
}

class _VisualizerBarState extends State<_VisualizerBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 7,
          height: 60 + 25 * _controller.value,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF65c3ec)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(.13),
                blurRadius: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
