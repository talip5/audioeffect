import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyStatefulWidget>{
  bool loading = false;
  double bar=0.1;
  AudioPlayer audioPlayer = AudioPlayer();
  String title='Audio Effect';
  double position1=0.0;
  double position2=0.0;
  int time=0;

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

  play() async {
    String playDir = '/storage/emulated/0/Music';
    int result = await audioPlayer.play('$playDir/deneme1.mp3', isLocal: true);
  }

  positionEvent() {
    //   player.onAudioPositionChanged.listen((Duration  p) => {
    //   print('Current position: $p');
    //       setState(() => position = p);
    // });
    audioPlayer.onAudioPositionChanged.listen((Duration p) {
      //print('Current position: $p');
      setState(() {
        int position = p.inSeconds;
        position1=position.toDouble();
        position2=(position1/100)*(100/time);
        title=position2.toString();
      });
      print(position2);
    });
  }

  duration() async {
    // player.onDurationChanged.listen((Duration d) {
    //   print('Max duration: $d');
    //   setState(() => duration = d);
    // });
    audioPlayer.onDurationChanged.listen((Duration d) {
      //print(d);
      time=d.inSeconds;
      print(time);
    });
  }

  volume() async{
    int result = await audioPlayer.setVolume(0.0);
  }

  @override
  void initState() {
    // TODO: implement initState
       super.initState();
    //requestCameraPermission();
    positionEvent();
    duration();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio',
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Audio Effect'),
              ElevatedButton(
                onPressed: () {
                  play();
                  volume();
                  setState(() {
                    loading = true;
                  });
                 print('Play');
                },
                child: Text('Play'),
              ),
              ElevatedButton(
                onPressed: () async {
                  int result = await audioPlayer.pause();
                  print('Pause');
                },
                child: Text('Pause'),
              ),
              ElevatedButton(
                onPressed: () async {
                  int result = await audioPlayer.stop();
                  print('Stop');
                },
                child: Text('Stop'),
              ),
              ElevatedButton(
                onPressed: () async {
                  int result =
                      await audioPlayer.seek(Duration(milliseconds: 1200));
                  print('Seek');
                },
                child: Text('Seek'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    loading = !loading;
                    print(loading);
                  });
                },
                child: Text('Progress Bar'),
              ),
              SizedBox(height: 20.0,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:38),
                child: Center(
                  child: loading?SizedBox(
                    width: 200,
                    child: LinearProgressIndicator(
                      minHeight: 30.0,
                      value: position2,
                      backgroundColor: Colors.white38,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),

                    ),
                  ):Text(
                    "No task to do",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
