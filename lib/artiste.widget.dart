import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_svg/svg.dart';
import 'package:songplayer/songs.widget.dart';

class ArtisteWidget extends StatefulWidget {
  @override
  State<ArtisteWidget> createState() => _ArtisteWidgetState();
}

class _ArtisteWidgetState extends State<ArtisteWidget> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  bool isGetting = true;
  List<ArtistInfo> artistes = [];
  getArtistes() async {
    setState(() {
      isGetting = true;
    });
    Future.delayed(Duration(seconds: 1), () async {
      artistes = await audioQuery.getArtists();
      print(artistes);
      setState(() {
        isGetting = false;
      });
    });
  }

  @override
  void initState() {
    if (mounted) {
      getArtistes();
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
        if (artistes.isEmpty) {
          return Center(
            child: Text("Aucune playlist n'as éte trouvé"),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            await getArtistes();
            return null;
          },
          child: ListView.builder(
              itemCount: artistes.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SongsWidget(
                                2, artistes[index].name, artistes[index].id)));
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
                        subtitle:
                            Text(artistes[index].numberOfTracks + " Chansons"),
                        title: Text(artistes[index].name)),
                  ),
                );
              }),
        );
      },
    ));
  }
}
