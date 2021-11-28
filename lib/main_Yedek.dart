import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  AudioPlayer audioPlayer = AudioPlayer();

  Future<void> requestCameraPermission() async {
    final serviceStatus = await Permission.storage.isGranted;

    bool isSorageOn = serviceStatus == ServiceStatus.enabled;

    final status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      print('Permission Granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Permission Permanently Denied');
      await openAppSettings();
    }
  }

  play() async{
    String playDir = '/storage/emulated/0/Music';
    int result = await audioPlayer.play('$playDir/deneme1.mp3', isLocal: true);
  }

  positionEvent(){
    //   player.onAudioPositionChanged.listen((Duration  p) => {
    //   print('Current position: $p');
    //       setState(() => position = p);
    // });
    audioPlayer.onAudioPositionChanged.listen((Duration p) {
      //print('Current position: $p');
      var position=p.inSeconds.toString();
      print(position);
    });
  }

  duration() async{
    // player.onDurationChanged.listen((Duration d) {
    //   print('Max duration: $d');
    //   setState(() => duration = d);
    // });
    audioPlayer.onDurationChanged.listen((Duration d) {
      print(d);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //requestCameraPermission();
    //positionEvent();
    //duration();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Audio Effect'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Audio Effect'),
              ElevatedButton(
                onPressed: (){
                  play();
                  duration();
                  print('Play');
                },
                child: Text('Play'),
              ),
              ElevatedButton(
                onPressed: () async{
                  int result = await audioPlayer.pause();
                  print('Pause');
                },
                child: Text('Pause'),
              ),
              ElevatedButton(
                onPressed: () async{
                  int result = await audioPlayer.stop();
                  print('Stop');
                },
                child: Text('Stop'),
              ),
              ElevatedButton(
                onPressed: () async{
                  int result = await audioPlayer.seek(Duration(milliseconds: 1200));
                  print('Seek');
                },
                child: Text('Seek'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
