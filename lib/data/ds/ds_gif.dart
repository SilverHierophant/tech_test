import 'package:tech_test/entities.dart';

abstract class GifDs {
  Future<List<Gif>> getGifPageByQuery(int pageNum, String query);
}
