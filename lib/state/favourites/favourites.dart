// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'favourites.g.dart';

@Riverpod(keepAlive: true)
class Favourites extends _$Favourites {
  @override
  List<String> build() {
    _getFavouritesFromStorage();
    return [];
  }

  _getFavouritesFromStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favourites = prefs.getStringList('favs');
    if (favourites != null) {
      state = favourites;
    }
  }

  Future<Result> addToFav(String path) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favourites = prefs.getStringList('favs');
    if (favourites != null) {
      if (favourites.contains(path)) {
        return Result(success: false, msg: 'Already exists in favourite');
      }
      favourites.insert(0, path);
      prefs.setStringList('favs', favourites);
    } else {
      prefs.setStringList('favs', [path]);
    }

    _getFavouritesFromStorage();
    return Result(success: true);
  }

  Future<Result> removeFromFav(String path) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favourites = prefs.getStringList('favs');
    if (favourites != null) {
      if (!favourites.contains(path)) {
        return Result(success: false, msg: 'Song is not favourite');
      }
      favourites.remove(path);
      prefs.setStringList('favs', favourites);
    }
    _getFavouritesFromStorage();
    return Result(success: true);
  }

  Future<Result> clearFav() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favs', []);
    _getFavouritesFromStorage();
    return Result(success: true);
  }
}

class Result {
  String? msg;
  bool success;
  Result({
    this.msg,
    required this.success,
  });
}
