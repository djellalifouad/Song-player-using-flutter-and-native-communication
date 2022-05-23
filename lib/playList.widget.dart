import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class PlayListWidget extends StatefulWidget {
  @override
  State<PlayListWidget> createState() => _PlayListWidgetState();
}

class _PlayListWidgetState extends State<PlayListWidget> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  bool isGetting = true;
  List<PlaylistInfo> playList = [];
  getPlaylist() async {
    setState(() {
      isGetting = true;
    });
    Future.delayed(Duration(seconds: 1), () async {
      playList = await audioQuery.getPlaylists();
      print(playList);
      setState(() {
        isGetting = false;
      });
    });
  }

  @override
  void initState() {
    if (mounted) {
      getPlaylist();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(
      builder: (context) {
        if (isGetting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (playList.isEmpty) {
          return Center(
            child: Text("Aucune playliste n'as éte trouvé"),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            await getPlaylist();
            return null;
          },
          child: ListView.builder(
              itemCount: playList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(title: Text(playList[index].name)),
                );
              }),
        );
      },
    ));
  }
}
