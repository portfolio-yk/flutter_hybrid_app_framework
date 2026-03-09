import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:path_provider/path_provider.dart';

Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<String> get externalPath async {
  return (await getApplicationDocumentsDirectory()).path;
}

_localFile(String filename) async {
  final path = await localPath;
  return File('$path/$filename');
}

Future<File> localFile(String filename) async {
  final path = await localPath;
  return File('$path/$filename');
}

_localDirectory(String dirname) async {
  final path = await localPath;
  return Directory('$path/$dirname');
}

Future<Directory> localDirectory(String dirname) async {
  final path = await localPath;
  return Directory('$path/$dirname');
}

Future<File> writeFile(String filename, String contents) async {
  final file = await _localFile(filename);
  return file.writeAsString(contents);
}

Future<File> writeFileAsBytes(String filename, List<int> bytes) async {
  File file = await _localFile(filename);
  return file.writeAsBytes(bytes);
}

void writeFileAsBytesSync(String filePath, List<int> bytes) {
  File file = File(filePath);
  file.writeAsBytesSync(bytes, mode: FileMode.append, flush: true);
}


Future<String?> readFile(String filename) async {
  try {
    final file = await _localFile(filename);
    String contents = await file.readAsString();
    return contents;
  } catch (e) {
    // 에러가 발생할 경우 0을 반환.
    return null;
  }
}

Future<bool> extractZip(String filename, { Function(double)? onExtracting }) async {
  try {
    File file = await _localFile(filename);
    final directory = await getApplicationDocumentsDirectory();
    await ZipFile.extractToDirectory(zipFile: file, destinationDir: directory, onExtracting: (zipEntry, progress) {
      if (onExtracting != null) {
        onExtracting(progress);
      }
      return ZipFileOperation.includeItem;
    });
    return true;
  } catch (e) {
    // 에러가 발생할 경우 0을 반환.
    return false;
  }
}

Future<bool> extractZipTargetDir(String filename, String target,{ Function(double)? onExtracting }) async {
  try {
    File file = await _localFile(filename);
    final directory = await getApplicationDocumentsDirectory();
    String targetPath = directory.path + target;
    final targetDirectory = new Directory(targetPath);
    await ZipFile.extractToDirectory(zipFile: file, destinationDir: targetDirectory, onExtracting: (zipEntry, progress) {
      if (onExtracting != null) {
        onExtracting(progress);
      }
      return ZipFileOperation.includeItem;
    });
    return true;
  } catch (e) {
    // 에러가 발생할 경우 0을 반환.
    return false;
  }
}


Future<bool> deleteFile(String filename) async {
  try {
    final file = await _localFile(filename);
    await file.delete();
    return true;
  } catch (e) {
    return false;
  }
}