import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_svg/svg.dart';
import 'package:songplayer/songs.widget.dart';

class AlbumWidget extends StatefulWidget {
  @override
  State<AlbumWidget> createState() => _AlbumWidgetState();
}

class _AlbumWidgetState extends State<AlbumWidget> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  bool isGetting = true;
  List<AlbumInfo> albums = [];
  getAlbums() async {
    setState(() {
      isGetting = true;
    });
    Future.delayed(Duration(seconds: 1), () async {
      albums = await audioQuery.getAlbums();
      setState(() {
        isGetting = false;
      });
    });
  }

  @override
  void initState() {
    if (mounted) {
      getAlbums();
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
        if (albums.isEmpty) {
          return Center(
            child: Text("Aucune playlist n'as été trouvé"),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            await getAlbums();
            return null;
          },
          child: ListView.builder(
              itemCount: albums.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SongsWidget(
                                1, albums[index].title, albums[index].id)));
                  },
                  child: Card(
                    child: ListTile(
                        trailing: Icon(
                          Icons.play_arrow,
                          color: Colors.amberAccent,
                        ),
                        leading: SvgPicture.asset(
                          'assets/music-album.svg',
                          height: 50,
                          width: 50,
                        ),
                        subtitle: Text(albums[index].numberOfSongs + " Chansons"),
                        title: Text(albums[index].title)),
                  ),
                );
              }),
        );
      },
    ));
  }
}
