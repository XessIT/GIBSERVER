import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoApp extends StatefulWidget {
  final String url;
  const VideoApp({Key? key, required this.url}) : super(key: key);

  @override
  State<VideoApp> createState() => _VideoAppState(url: url);
}

class _VideoAppState extends State<VideoApp> {

  late VideoPlayerController _controller;
  bool _isFullScreen = false;
  late String url;
  bool _isPlaying = false;
  _VideoAppState({Key? key, required this.url});
  @override
  void initState() {
    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

String _videoDuration(Duration duration){
   String twoDigits(int n) =>n.toString().padLeft(2,'0');
   final hours= twoDigits(duration.inHours);
   final minutes= twoDigits(duration.inMinutes.remainder(60));
   final seconds= twoDigits(duration.inSeconds.remainder(60));
   return[
     if(duration.inHours > 0) hours,
     minutes,
     seconds
   ].join(':');
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () {
          setState(() {
            _isFullScreen = false;
          });
        },
        onDoubleTap: () {
          setState(() {
            _isFullScreen = !_isFullScreen;
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: _controller.value.isInitialized
                  ? SizedBox(
                width: _isFullScreen ? double.infinity : null,
                height: _isFullScreen ? double.infinity : 540,
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              )
                  : Container(),
            ),
            if (_controller.value.isInitialized && !_controller.value.isPlaying)
              IconButton(
                icon: Icon(Icons.play_arrow),
                iconSize: 72,
                onPressed: () {
                  setState(() {
                    _isPlaying = true;
                  });
                  _controller.play();
                },
              ),
            if (_controller.value.isInitialized && _controller.value.isPlaying)
              IconButton(
                icon: Icon(Icons.pause),
                iconSize: 72,
                onPressed: () {
                  setState(() {
                    _isPlaying = false;
                  });
                  _controller.pause();
                },
              ),
            if (_controller.value.isInitialized)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: _controller,
                        builder: (context, VideoPlayerValue value, child) {
                          return Text(
                            _videoDuration(value.position),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          );
                        },
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 20,
                          child: VideoProgressIndicator(
                            _controller,
                            allowScrubbing: true,
                            padding: const EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 12,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        _videoDuration(_controller.value.duration),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],

        ),

      ),

    );
  }
}
