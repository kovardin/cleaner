import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cleaner/pigeons/junk/search.dart';

class JunkFile {
  final String? application;
  final String? path;
  final String? package;
  final String? icon;
  final int? size;
  final int? type;

  JunkFile({this.application, this.path, this.package, this.icon, this.size, this.type});

  factory JunkFile.fromJson(Map<String, dynamic> json) {
    return JunkFile(
      application: json['applicationName'].toString(),
      package: json['packageName'].toString(),
      path: json['path'].toString(),
      icon: json['icon'] as String,
      size: json['size'] as int,
      type: json['type'] as int,
    );
  }
}

class Result {
  final int size;
  final List<JunkFile> items;

  Result({required this.size, required this.items});
}

class SearchService {
  final search = JunkSearch();

  SearchService() {}

  Future<Result> getDownloadFiles() async {
    final response = await search.getDownloadFiles();
    return Result(size: response.size ?? 0, items: convert(response));
  }

  Future<Result> getApkFiles() async {
    final response = await search.getApkFiles();
    return Result(size: response.size ?? 0, items: convert(response));
  }

  Future<Result> getCacheFiles() async {
    final response = await search.getCacheFiles();
    return Result(size: response.size ?? 0, items: convert(response));
  }

  Future<Result> getLargeFiles() async {
    final response = await search.getLargeFiles();
    return Result(size: response.size ?? 0, items: convert(response));
  }

  List<JunkFile> convert(SearchResponse response) {
    if (response.items?.isEmpty ?? true) {
      return [];
    }

    List<JunkFile> result = [];
    for (var item in response.items!) {
      final data = json.decode(item.toString());
      result.add(JunkFile.fromJson(data));
    }

    return result;
  }
}
