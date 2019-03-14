import 'dart:async';
import 'dart:collection';

import 'package:tech_test/data/gif_repository.dart';
import 'package:tech_test/entities.dart';
import 'package:tuple/tuple.dart';

class GifsViewModel {
  GifRepository _gifRepository;

  String lastQuery = "";
  int queryPageNum = 0;

  Stream<Tuple2<bool, List<Gif>>> gifsStream;
  StreamController<Tuple2<bool, List<Gif>>> _gifsController;

  GifsViewModel(this._gifRepository);

  List<Gif> _gifs = List();

  HashMap<int, List<Gif>> _pages = HashMap();

  initVm(StreamController<Tuple2<bool, List<Gif>>> gifsController) {
    this._gifsController = gifsController;
    this.gifsStream = gifsController.stream;
  }

  newGifsPage() {
    _gifRepository.getGifPageByQuery(queryPageNum, lastQuery).then((it) {
      ++queryPageNum;
      _gifs.addAll(it);
      _gifsController.add(Tuple2(false, _gifs));
    }, onError: (err) {
      print("Should be handled in separate stream");
    });
  }

  newGifsQuery(String query) {
    _gifRepository.getGifPageByQuery(0, query).then((it) {
      lastQuery = query;
      _pages.clear();
      _pages[0] = it;

      _gifs.clear();
      _gifs.addAll(it);
      _gifsController.add(Tuple2(true, _gifs));
    }, onError: (err) {
      print("Should be handled in separate stream");
    });
  }
}
