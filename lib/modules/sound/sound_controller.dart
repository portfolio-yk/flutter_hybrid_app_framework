import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:hybrid_module/basic/util/file.dart';

class SoundController {
  static late final SoundController instance;
  static late final AudioPlayer audioPlayer;
  static late final AudioPlayer subPlayer;
  bool isPlaying = false;
  StreamSubscription? playerCompleteListener;
  StreamSubscription? playerStopListener;

  final AudioContext audioContext = AudioContext(
      android: AudioContextAndroid(
          isSpeakerphoneOn: true,
          stayAwake: true,
          contentType: AndroidContentType.sonification,
          usageType: AndroidUsageType.assistanceSonification,
          audioFocus: AndroidAudioFocus.gainTransient),
      iOS: AudioContextIOS(
          defaultToSpeaker: true,
          category: AVAudioSessionCategory.playback,
          options: [
            AVAudioSessionOptions.defaultToSpeaker,
            AVAudioSessionOptions.mixWithOthers
          ]));

  static init() {
    instance = SoundController._init();
  }

  SoundController._init() {
    _internal();
  }

  _internal() {
    AudioPlayer.global.setGlobalAudioContext(audioContext);
    SoundController.audioPlayer = AudioPlayer();
    SoundController.subPlayer = AudioPlayer();
  }

  getDeviceFileSource(String fullPath) async {
    String fileName = fullPath.split('/').last;
    String filePath = fullPath.replaceAll(fileName, "");

    if (filePath == "" || fileName == "") {
      return throw Error();
    }

    final soundDir = Directory(filePath);
    List<FileSystemEntity> soundFolders = await soundDir.list().toList();

    if (soundFolders.isNotEmpty) {
      Iterable<FileSystemEntity> soundList = soundFolders
          .where((FileSystemEntity file) => file.path.contains(fileName));

      final Iterable<File> files = soundList.whereType<File>();

      File soundFile =
      files.firstWhere((File file) => file.path.contains(fileName));

      return DeviceFileSource(soundFile.path);
    } else {
      throw Error();
    }
  }

  getAssetsSource(path) {
    return AssetSource(path);
  }

  playSound(
      {bool? isSubSound,
        required String filePath,
        required Source audioSource}) async {
    playerCompleteListener =
        SoundController.audioPlayer.onPlayerComplete.listen((event) {
          isPlaying = false;
          print("stop");
        });

    if (isPlaying || (isSubSound ?? false)) {
      await SoundController.subPlayer.play(audioSource);
      print("playing");
    } else {
      isPlaying = true;
      await SoundController.audioPlayer.play(audioSource);
    }
    return true;
  }

  replaySound(Source source) {
    final completer = Completer();
    playerCompleteListener =
        SoundController.audioPlayer.onPlayerComplete.listen((event) {
          print('끄읕');
          completer.complete(true);
        });
    playerStopListener =
        SoundController.audioPlayer.onPlayerStateChanged.listen((event) {
          print('멈춤$event');
          if (event.toString() == 'PlayerState.stop') {
            completer.complete(false);
          }
        });
    SoundController.audioPlayer.play(source);
    return completer.future;
  }

  stopSound() {
    SoundController.audioPlayer.stop();
  }

  cancel() {
    playerCompleteListener?.pause();
    return playerStopListener?.pause();
  }
}
