import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'loading.g.dart';

@Riverpod(keepAlive: true)
class Loading extends _$Loading {
  @override
  bool build() {
    return false;
  }

  update(bool isLoading) {
    state = isLoading;
  }
}
