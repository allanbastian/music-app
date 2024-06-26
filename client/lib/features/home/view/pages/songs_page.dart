import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SongsPage extends ConsumerWidget {
  const SongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentlyPlayedSongs = ref.watch(homeViewmodelProvider.notifier).getRecentlyPlayedSongs();
    final currentSong = ref.watch(currentSongNotifierProvider);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: currentSong == null
          ? null
          : BoxDecoration(
              gradient: LinearGradient(
                colors: [hexToColor(currentSong.hexCode), Pallete.transparentColor],
                stops: const [0.0, 0.3],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 36),
            child: SizedBox(
              height: 280,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3,
                  crossAxisSpacing: 8,
                  mainAxisExtent: 8,
                ),
                itemCount: recentlyPlayedSongs.length,
                itemBuilder: (context, index) {
                  final song = recentlyPlayedSongs[index];
                  return GestureDetector(
                    onTap: () {
                      ref.read(currentSongNotifierProvider.notifier).upadteSong(song);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(color: Pallete.borderColor, borderRadius: BorderRadius.circular(6)),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
                              image: DecorationImage(image: NetworkImage(song.song_url), fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              song.song_name,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Latest Today', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700)),
          ),
          ref.watch(getAllSongsProvider).when(
                data: (songs) {
                  return SizedBox(
                    height: 260,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: songs.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        return GestureDetector(
                          onTap: () => ref.read(currentSongNotifierProvider.notifier).upadteSong(song),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: NetworkImage(song.thumbnail_url),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    song.song_name,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    song.artist,
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Pallete.subtitleText),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                error: (err, stackTrace) {
                  return Center(child: Text(err.toString()));
                },
                loading: () => const Loader(),
              ),
        ],
      ),
    );
  }
}
