import 'package:audioplayers/audioplayers.dart';

class SoundPlayer {
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static Future<void> playSound(String soundPath) async {
    print("Playing sound from: $soundPath");
    await _audioPlayer.play(AssetSource(soundPath));
  }

  static Future<void> stopSound() async {
    await _audioPlayer.stop();
  }

  static Future<void> pauseSound() async {
    await _audioPlayer.pause();
  }

  static Future<void> resumeSound() async {
    await _audioPlayer.resume();
  }
}
