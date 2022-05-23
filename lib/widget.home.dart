import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:songplayer/database/database.helper.dart';
import 'package:songplayer/playList.widget.dart';
import 'package:songplayer/widget.favorite.dart';
import 'package:songplayer/widget.search.dart';

import 'album.widget.dart';
import 'artiste.widget.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  int _currentIndex = 0;
  PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerScrimColor: Colors.black,
      drawer: Drawer(),
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              CupertinoIcons.heart_circle,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FavoriteWidget()));
            }),
        actions: [
          Row(
            children: [
              InkWell(
                onTap: () async {
                  List<SongInfo> songInfo = await audioQuery.getSongs();
                  showSearch(context: context, delegate: SearchSongs(songInfo));
                },
                child: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              )
            ],
          ),
          SizedBox(
            width: 15,
          ),
        ],
        title: Row(
          children: [
            Text(
              "Lecteur",
              style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1)),
            ),
            Icon(
              Icons.play_arrow,
              color: Colors.black,
            )
          ],
        ),
        backgroundColor: Colors.amberAccent,
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            PlayListWidget(),
            AlbumWidget(),
            ArtisteWidget(),

          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              activeColor: Colors.amber,
              inactiveColor: Colors.black,
              title: Text('Playlist'),
              icon: Icon(Icons.playlist_play)),
          BottomNavyBarItem(
              activeColor: Colors.amber,
              inactiveColor: Colors.black,
              title: Text('Albums'),
              icon: Icon(Icons.album)),
          BottomNavyBarItem(
              activeColor: Colors.amber,
              inactiveColor: Colors.black,
              title: Text('Artiste'),
              icon: Icon(Icons.person)),

        ],
      ),
    );
  }
}
