import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_svg/svg.dart';

class SearchSongs extends SearchDelegate<String> {
  List<SongInfo> songsInfos;
  SearchSongs(this.songsInfos);
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  @override
  String get searchFieldLabel => "Trouver une chanson";
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.clear))
    ];
  }
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.clear));
  }

  @override
  Widget buildResults(BuildContext context) {
    var songs = songsInfos
        .where((element) => element.displayName
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
                onTap: () {},
                leading: SvgPicture.asset(
                  'assets/music-album.svg',
                  height: 50,
                  width: 50,
                ),
                subtitle: Text(songs[index].title.toString()),
                title: Text(songs[index].displayName.toString())),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return Container();
  }
}
