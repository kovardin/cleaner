import 'dart:convert';

import 'package:cleaner/pigeons/junk/cleaning.dart';


class CleaningFile {
  final String? application;
  final String? path;
  final String? package;
  final int? type;

  CleaningFile({this.application, this.path, this.package, this.type});

  factory CleaningFile.fromJson(Map<String, dynamic> json) {
    return CleaningFile(
      application: json['applicationName'].toString(),
      package: json['packageName'].toString(),
      path: json['path'].toString(),
      type: json['type'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'applicationName': this.application,
      'packageName': this.package,
      'path': this.path,
      'type': this.type,
    };
  }
}

class CleaningService {
  final service = new JunkCleaning();

  Future<bool> clean(List<CleaningFile> files) async {
    var req = CleaningRequest();
    req.files = [];

    for (var file in files) {
      req.files?.add(json.encode(file.toJson()));
    }

    final resp = await service.clean(req);

    return resp.status ?? false;
  }
}
