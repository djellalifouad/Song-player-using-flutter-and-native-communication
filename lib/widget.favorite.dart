import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_svg/svg.dart';
import 'package:songplayer/widget.songDetail.dart';

import 'const/widget.message.dart';
import 'database/database.helper.dart';

class FavoriteWidget extends StatefulWidget {
  @override
  State<FavoriteWidget> createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool isGetting = false;
  List<SongInfo> songs = [];
  SongProvider songProvider = SongProvider();
  List<Song> songsFavorite = [];
  @override
  void initState() {
    if (mounted) {
      getSongs();
    }
    // TODO: implement initState
    super.initState();
  }
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  getSongs() async {
    songsFavorite.clear();
    songsFavorite = await songProvider.songs();
    List<String> songsFavoriteInteger = [];
    for (int i = 0; i < songsFavorite.length; i++) {
      songsFavoriteInteger.add(songsFavorite[i].id.toString());
    }
    if(songsFavoriteInteger.isEmpty) {
      songs.clear();
      setState(() {
      });
      return;
    }
    songs = await audioQuery.getSongsById(ids: songsFavoriteInteger);
    setState(() {});
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
          title: Text('Mes favoris',style: TextStyle(color: Colors.black),),
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
                child: Text("Aucune chanson n'as éte trouvé"),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                await getSongs();
                return null;
              },
              child: ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                          onTap: () {
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
                                Song song = Song(id: int.parse(songs[index].id));
                                songProvider.insertSong(song);
                                songsFavorite.add(song);
                                setState(() {});
                                showMessage('Chanson ajouté avec succées');
                              } else {
                                Song song = Song(id: int.parse(songs[index].id));
                                songProvider
                                    .deleteDog(int.parse(songs[index].id));
                                songsFavorite.removeWhere((element) =>
                                element.id.toString() ==
                                    songs[index].id.toString());
                                setState(() {});
                                showMessage('Chanson supprimé avec succées');
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
