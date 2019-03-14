import 'package:tech_test/entities.dart';

import 'ds/ds_gif.dart';

class GifRepository {
  GifDs _gifDs;

  GifRepository(this._gifDs);

  Future<List<Gif>> getGifPageByQuery(int pageNum, String query) {
    return _gifDs.getGifPageByQuery(pageNum, query);
  }
}
