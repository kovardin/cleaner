import 'package:pigeon/pigeon.dart';

class SearchResponse {
  int? size;
  List? items;
}

@HostApi()
abstract class JunkSearch {
  @async
  SearchResponse getApkFiles();

  @async
  SearchResponse getDownloadFiles();

  @async
  SearchResponse getCacheFiles();

  @async
  SearchResponse getLargeFiles();
}
