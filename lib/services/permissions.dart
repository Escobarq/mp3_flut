import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class Permissions {
  final _audioQuery = OnAudioQuery();

  Future<void> _requestPermissions() async {
    final a = await Permission.storage.request();
    if (kDebugMode) {
      print(a);
    }
  }

  Widget build(BuildContext context, onTap) {
    return FutureBuilder(
      future: _requestPermissions().then((_) => _audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      )),
      builder: (context, AsyncSnapshot<List<SongModel>> item) {
        if (item.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator.adaptive(
            strokeWidth: 5.0,
          );
        } else if (item.hasError) {
          return Text('Error: ${item.error}');
        } else if (!item.hasData || item.data!.isEmpty) {
          return const Text('No songs found');
        }

        return ListView.builder(
          itemCount: item.data!.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(item.data![index].title),
              subtitle: Text(item.data![index].artist ?? 'Unknown Artist'),
              leading: QueryArtworkWidget(
                id: item.data![index].id,
                type: ArtworkType.AUDIO,
              ),
              onTap: onTap,
            );
          },
        );
      },
    );
  }
}