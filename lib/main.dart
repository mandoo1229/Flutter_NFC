import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:aws_polly_api/polly-2016-06-10.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() async{
  // dotenv를 통해서 .env파일을 활성화하여 숨긴 api키를 가져와 사용할 수 있도록 함.
  await dotenv.load(fileName: "assets/config/.env");
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


  // 변수명을 초기화 합니다.
  late String region;
  late String accessKey;
  late String secretKey;
  late Polly _polly;


  // AWS Polly API키를 숨겨서 사용합니다.
  @override
  void initState() {
    super.initState();
    region = dotenv.get('REGION');
    accessKey = dotenv.get('ACCESSKEY');
    secretKey = dotenv.get('SECRETKEY');

    _polly = Polly(
        region :region,
      credentials: AwsClientCredentials(
          accessKey: accessKey, secretKey: secretKey),
    );

  }

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
