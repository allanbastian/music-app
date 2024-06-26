import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [hexToColor(currentSong!.hexCode), const Color(0xff121212)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Scaffold(
        backgroundColor: Pallete.transparentColor,
        appBar: AppBar(
          backgroundColor: Pallete.transparentColor,
          leading: Transform.translate(
            offset: const Offset(-15, 0),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset('assets/images/pull_down_arrow.png', color: Pallete.whiteColor),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Hero(
                  tag: 'music-image',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(currentSong.thumbnail_url),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentSong.song_name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Pallete.whiteColor,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            currentSong.artist,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Pallete.subtitleText,
                            ),
                          ),
                        ],
                      ),
                      const Expanded(child: SizedBox()),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.heart, color: Pallete.whiteColor),
                      ),
                    ],
                  ),
                  StreamBuilder(
                    stream: songNotifier.audioPlayer!.positionStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox();
                      }
                      final pos = snapshot.data;
                      final duration = songNotifier.audioPlayer?.duration;
                      double sliderValue = 0.0;
                      if (pos != null && duration != null) {
                        sliderValue = pos.inMilliseconds / duration.inMilliseconds;
                      }
                      return Column(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Pallete.whiteColor,
                              inactiveTrackColor: Pallete.whiteColor.withOpacity(0.117),
                              thumbColor: Pallete.whiteColor,
                              trackHeight: 4,
                              overlayShape: SliderComponentShape.noOverlay,
                            ),
                            child: Slider(
                              value: sliderValue,
                              min: 0,
                              max: 1,
                              onChanged: (val) {
                                sliderValue = val;
                              },
                              onChangeEnd: songNotifier.seek,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '${pos?.inMinutes}:${(pos?.inSeconds ?? 0) < 10 ? '0${pos?.inSeconds}' : '${pos?.inSeconds}'}',
                                style: const TextStyle(
                                  color: Pallete.subtitleText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                              Text(
                                '${duration?.inMinutes}:${(duration?.inSeconds ?? 0) < 10 ? '0${duration?.inSeconds}' : '${duration?.inSeconds}'}',
                                style: const TextStyle(
                                  color: Pallete.subtitleText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset('assets/images/shuffle.png', color: Pallete.whiteColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset('assets/images/previous_song.png', color: Pallete.whiteColor),
                      ),
                      IconButton(
                        onPressed: songNotifier.playPause,
                        icon: Icon(
                          songNotifier.isPlaying ? CupertinoIcons.pause_circle_fill : CupertinoIcons.play_circle_fill,
                          size: 80,
                          color: Pallete.whiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset('assets/images/next_song.png', color: Pallete.whiteColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset('assets/images/repeat.png', color: Pallete.whiteColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset('assets/images/connect_device.png', color: Pallete.whiteColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset('assets/images/playlist.png', color: Pallete.whiteColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
