import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'error_list.g.dart';

@Riverpod(keepAlive: true)
class ErrorList extends _$ErrorList {
  @override
  List<String> build() {
    return [];
  }


  Future<bool> remove(String path) async {
    if (!state.contains(path)) {
      return false;
    }
    final values = state;
    values.remove(path);
    state = values;
    return true;
  }

  Future<bool> add(String path) async {
    if(state.contains(path)){
      return false;
    }
    final values = state;
    values.add(path);
    state = values;
    return true;
  }

}
