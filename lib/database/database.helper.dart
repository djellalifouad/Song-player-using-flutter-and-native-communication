import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tableSong = 'song';
final String columnId = '_id';

class Song {
  int id;
  Song({this.id});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Song{id: $id,}';
  }
}

class SongProvider {
  Database database2;
  SongProvider() {
    database();
  }
  database() async {
    final database2 = await openDatabase(
      join(await getDatabasesPath(), 'songs.db'),
    );
    return database2;
  }

  Future<void> insertSong(Song song) async {
    // Get a reference to the database.
    final db = await database2 ?? await database();

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'songs',
      song.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Song>> songs() async {
    // Get a reference to the database.
    final db = await database2 ?? await database();

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('songs');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Song(
        id: maps[i]['id'],
      );
    });
  }

  Future<void> deleteDog(int id) async {
    // Get a reference to the database.
    final db = await database2 ?? await database();

    // Remove the Dog from the database.
    await db.delete(
      'songs',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}
