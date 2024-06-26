import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/view/widgets/music_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);
    if (currentSong == null) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return const MusicPlayer();
            },
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              final tween = Tween(begin: const Offset(0, 1), end: Offset.zero).chain(CurveTween(curve: Curves.easeIn));
              animation.drive(tween);
              final offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
          ),
        );
      },
      child: Stack(
        children: [
          Hero(
            tag: 'music-image',
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: 66,
              width: MediaQuery.of(context).size.width - 16,
              decoration: BoxDecoration(
                color: hexToColor(currentSong.hexCode),
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.all(9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: NetworkImage(currentSong.song_url), fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(currentSong.song_name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                          Text(currentSong.artist, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Pallete.subtitleText)),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.heart, color: Pallete.whiteColor),
                      ),
                      IconButton(
                        onPressed: songNotifier.playPause,
                        icon: Icon(
                          songNotifier.isPlaying ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill,
                          color: Pallete.whiteColor,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder(
            stream: songNotifier.audioPlayer?.positionStream,
            builder: (context, snapshot) {
              final pos = snapshot.data;
              final duration = songNotifier.audioPlayer?.duration;
              double sliderValue = 0.0;
              if (pos != null && duration != null) {
                sliderValue = pos.inMilliseconds / duration.inMilliseconds;
              }
              return Positioned(
                bottom: 0,
                left: 8,
                child: Container(
                  height: 2,
                  width: sliderValue * (MediaQuery.of(context).size.width - 32),
                  decoration: BoxDecoration(
                    color: Pallete.whiteColor,
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 8,
            child: Container(
              height: 2,
              width: MediaQuery.of(context).size.width - 32,
              decoration: BoxDecoration(
                color: Pallete.inactiveSeekColor,
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
