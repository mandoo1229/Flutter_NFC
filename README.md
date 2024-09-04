<h3>Flutter NFC 태그기 읽는 기능 </h3>
<br/>

공부용으로 만들었습니다.

<h3>Dart Version </h3>
<br/>
<div>
Dart SDK version: 3.5.1
</div>

<br/>

TTS 설치 (터미널에서 실행하면 됩니다.)
```
flutter pub add flutter_tts
```

<br/>

안드로이드 설정
<br/>
/android/app/build.gradle 경로에 

```
<queries>
    <intent>
    <action android:name="android.intent.action.TTS_SERVICE" />
    </intent>
</queries>
```
추가