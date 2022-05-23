import 'package:flutter/services.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class SongController {
  static var platform = const MethodChannel("flutter.native.audio.bridge");
  static startSong(String path, String title, String description,
      List<SongInfo> songInfo, int index) async {
    String response = "";
    try {
      List<Map> maps = [];
      for (int i = 0; i < songInfo.length; i++) {
        maps.add({
          
          "filePath": songInfo[i].filePath, 
          "title": songInfo[i].displayName.toString(),
          "desc" : songInfo[i].artist.toString()
          });
      }
      String result = await platform.invokeMethod("startPlayer",
          {"url": path, "title": "title", "desc": description, "list": maps,"index" : index});
      response = result;
    } on PlatformException catch (e) {
      response = "Failed to invoke native method ${e.message.toString()}";
      print(response);
    }
  }

  static resumeSong(String path, String title, String description) async {
    String response = "";
    try {
      String result = await platform.invokeMethod(
          "resumePlayer", {"url": path, "title": "title", "desc": description});
      response = result;
    } on PlatformException catch (e) {
      response = "Failed to invoke native method ${e.message.toString()}";
      print(response);
    }
  }

  static pauseSong(
    String path,
  ) async {
    String response = "";
    try {
      String result = await platform.invokeMethod("pausePlayer", {
        "url": path,
      });
      response = result;
    } on PlatformException catch (e) {
      response = "Failed to invoke native method ${e.message.toString()}";
      print(response);
    }
  }
}
