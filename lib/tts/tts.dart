import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io';

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
  FlutterTts flutterTts = FlutterTts();
  /*
  한국어 = "ko-KR"
  일본어 = "ja-JP"
  영어 = "en-US"
  중국어 = "zh-CN"
   */

  String language = "ko-KR";

  /* 음성 설정
  한국어 여성 {"name": "ko-kr-x-ism-local", "locale": "ko-KR"}
	영어 여성 {"name": "en-us-x-tpf-local", "locale": "en-US"}
  일본어 여성 {"name": "ja-JP-language", "locale": "ja-JP"}
  중국어 여성 {"name": "cmn-cn-x-ccc-local", "locale": "zh-CN"}
  중국어 남성 {"name": "cmn-cn-x-ccd-local", "locale": "zh-CN"}
  */

  Map<String, String> voice = {"name": "ko-kr-x-ism-local", "locale": "ko-KR"};
  String engine = "com.google.android.tts"; // Android에서만 사용 가능
  double volume = 2.5;
  double pitch = 1.0;
  double rate = 0.5;

  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initTts();
  }

  initTts() async {
    if (Platform.isIOS) {
      // iOS에서만 적용
      await initTtsIosOnly();
    }
    await flutterTts.setLanguage(language);
    await flutterTts.setVoice(voice);
    await flutterTts.setVolume(volume);
    await flutterTts.setPitch(pitch);
    await flutterTts.setSpeechRate(rate);

    if (Platform.isAndroid) {
      // Android에서만 적용
      await flutterTts.setEngine(engine);
    }
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

  Future<void> _speak(String voiceText) async {
    await flutterTts.speak(voiceText);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: textEditingController,
          ),
          ElevatedButton(
              onPressed: () {
                _speak(textEditingController.text);
              },
              child: const Text('read'))
        ],
      ),
    );
  }
}