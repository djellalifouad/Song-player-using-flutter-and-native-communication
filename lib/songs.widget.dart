import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_svg/svg.dart';
import 'package:songplayer/const/widget.message.dart';
import 'package:songplayer/database/database.helper.dart';
import 'package:songplayer/widget.songDetail.dart';

class SongsWidget extends StatefulWidget {
  int index;
  String title;
  dynamic id;
  SongsWidget(
    this.index,
    this.title,
    this.id,
  );
  @override
  State<SongsWidget> createState() => _SongsWidgetState();
}

class _SongsWidgetState extends State<SongsWidget> {
  SongProvider songProvider = SongProvider();
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  bool isGetting = true;
  List<SongInfo> songs = [];
  List<Song> songsFavorite = [];

  getArtistes() async {
    songsFavorite = await songProvider.songs();
    setState(() {
      isGetting = true;
    });
    Future.delayed(Duration(seconds: 1), () async {
      if (widget.index == 0) {
        songs = await audioQuery.getSongsFromPlaylist(playlist: widget.id);
      } else if (widget.index == 1) {
        songs = await audioQuery.getSongsFromAlbum(albumId: widget.id);
      } else {
        songs = await audioQuery.getSongsFromArtist(artistId: widget.id);
      }
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
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),

          title: Row(
            children: [
              Builder(builder: (context) {
                if (widget.index == 0) {
                  return Container(
                    width: 200,
                    child: Text(
                      "PlayList ${widget.title}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1)),
                    ),
                  );
                } else if (widget.index == 1) {
                  return Container(
                    width: 200,
                    child: Text(
                      "Album ${widget.title}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1)),
                    ),
                  );
                } else {
                  return Container(
                    width: 200,
                    child: Text(
                      "Artiste ${widget.title}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1)),
                    ),
                  );
                }
              }),
            ],
          ),
          backgroundColor: Colors.amberAccent,
        ),
        body: Builder(
          builder: (context) {
            if (isGetting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (songs.isEmpty) {
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
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SongDetailWidget(
                                          current_index: index,
                                          list: songs,
                                        )));
                          },
                          trailing: InkWell(
                            onTap: () {
                              if (songsFavorite
                                  .where((element) =>
                                      element.id.toString() ==
                                      songs[index].id.toString())
                                  .isEmpty) {
                                Song song =
                                    Song(id: int.parse(songs[index].id));
                                songProvider.insertSong(song);
                                songsFavorite.add(song);
                                setState(() {});
                                showMessage('chanson ajouté avec succées');
                              } else {
                                Song song =
                                    Song(id: int.parse(songs[index].id));
                                songProvider
                                    .deleteDog(int.parse(songs[index].id));
                                songsFavorite.removeWhere((element) =>
                                    element.id.toString() ==
                                    songs[index].id.toString());
                                setState(() {});
                                showMessage('chanson supprimé avec succées');

                              }
                            },
                            child: Icon(
                              songsFavorite
                                      .where((element) =>
                                          element.id.toString() ==
                                          songs[index].id.toString())
                                      .isNotEmpty
                                  ? CupertinoIcons.heart_fill
                                  : CupertinoIcons.heart,
                              color: Colors.amber,
                            ),
                          ),
                          leading: SvgPicture.asset(
                            'assets/music-album.svg',
                            height: 50,
                            width: 50,
                          ),
                          subtitle: Text(songs[index].title.toString()),
                          title: Text(songs[index].displayName.toString())),
                    );
                  }),
            );
          },
        ));
  }
}
