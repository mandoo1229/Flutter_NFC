import 'dart:convert';
import 'dart:io';
import 'package:aws_polly/aws_polly.dart';
import 'package:aws_polly_api/polly-2016-06-10.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:typed_data';

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: SafeArea(child: MyTts()),
    ),
  ));
}

class MyTts extends StatefulWidget {
  const MyTts({super.key});

  @override
  State<MyTts> createState() => _MyTtsState();
}

class _MyTtsState extends State<MyTts> {
  final AudioPlayer audioPlayer = AudioPlayer();
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController textEditingController = TextEditingController(text: "초기값 설정");

  String language = "ko-KR";
  Map<String, String> voice = {"name": "ko-kr-x-ism-local", "locale": "ko-KR"};
  double volume = 1.0;
  double pitch = 1.0;
  double rate = 0.5;



  @override
  void initState() {
    super.initState();
    initTts();
  }

  Future<void> initTts() async {
    if (Platform.isIOS) {
      await initTtsIosOnly();
    }
    await flutterTts.setLanguage(language);
    await flutterTts.setVoice(voice);
    await flutterTts.setVolume(volume);
    await flutterTts.setPitch(pitch);
    await flutterTts.setSpeechRate(rate);
  }

  Future<void> initTtsIosOnly() async {
    await flutterTts.setSharedInstance(true);
    await flutterTts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.ambient,
      [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        IosTextToSpeechAudioCategoryOptions.mixWithOthers
      ],
      IosTextToSpeechAudioMode.voicePrompt,
    );
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }



  final Polly _polly = Polly(
    region: "",
    credentials: AwsClientCredentials(
      accessKey: "",
      secretKey: "",
    ),
  );


  Future<void> _speakWithPolly(String text) async {
    try {
      final response = await _polly.synthesizeSpeech(
        outputFormat: OutputFormat.mp3,
        text: text,
        voiceId: VoiceId.seoyeon,
      );

      if (response.audioStream != null) {
        Uint8List audioBytes = response.audioStream!;
        await audioPlayer.play(BytesSource(audioBytes));
      } else {
        print("Audio stream is null");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: textEditingController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter text',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _speakWithPolly(textEditingController.text);
            },
            child: const Text('Read'),
          ),
        ],
      ),
    );
  }
}
