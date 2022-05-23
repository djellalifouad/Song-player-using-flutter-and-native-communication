import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart';
import 'package:songplayer/const/widget.message.dart';
import 'package:songplayer/database/database.helper.dart';
import 'package:songplayer/songController/song.controller.dart';

class SongDetailWidget extends StatefulWidget {
  List<SongInfo> list;
  int current_index;
  SongDetailWidget({this.current_index, this.list});

  @override
  State<SongDetailWidget> createState() => _SongDetailWidgetState();
}

class _SongDetailWidgetState extends State<SongDetailWidget> {
  getNext() {
    if (widget.current_index == widget.list.length - 1) {
      showMessage("il n'éxiste pas");
      return;
    }
    widget.current_index++;
    setState(() {});
    play();
  }
  play() {
    SongController.startSong(
        widget.list[widget.current_index].filePath, "title", "description",widget.list,widget.current_index);
    setState(() {
      isPlay = true;
    });
  }

  resume() {
    SongController.resumeSong(
        widget.list[widget.current_index].filePath, "title", "description");
    setState(() {
      isPlay = true;
    });
  }

  bool isPlay = false;
  pause() {
    SongController.pauseSong(widget.list[widget.current_index].filePath);
    setState(() {
      isPlay = false;
    });
  }

  @override
  void initState() {
    play();
    super.initState();
  }

  getPrevious() {
    if (widget.current_index == 0) {
      showMessage("il n'éxiste pas");
      return;
    }
    widget.current_index--;
    setState(() {});
    play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: 200,
          child: Text(
            "${widget.list[widget.current_index].displayName}",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1)),
          ),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.amberAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/music-album.svg',
              height: 200,
              width: 200,
            ),
            SizedBox(
              height: 30,
            ),
            Container(
                width: 300,
                child: Text(
                  widget.list[widget.current_index].displayName,
                  textAlign: TextAlign.center,
                )),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      getPrevious();
                    },
                    child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.amber,
                        ),
                        child: Icon(
                          Icons.skip_previous_sharp,
                          size: 20,
                        )),
                  ),
                  InkWell(
                    onTap: () {
                      if (isPlay) {
                        pause();
                      } else {
                        resume();
                      }
                    },
                    child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.amber,
                        ),
                        child: Icon(
                          !isPlay ? Icons.play_arrow : Icons.pause,
                          size: 20,
                        )),
                  ),
                  InkWell(
                    onTap: () {
                      getNext();
                    },
                    child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.amber,
                        ),
                        child: Icon(
                          Icons.skip_next_sharp,
                          size: 20,
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
