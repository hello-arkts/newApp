
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import '../../../IConstant.dart';

class VideoPlayerWidget extends StatefulWidget {

  String videoUrl;
  double volume;

  VideoPlayerWidget({ required this.videoUrl , required this.volume});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();

}
class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {

  late VideoPlayerController _controller;
  late String _videoUrl;
  late double _volume;

  @override
  void initState() {
    super.initState();
    _videoUrl = widget.videoUrl;
    _volume = widget.volume;
    _controller = VideoPlayerController.networkUrl(Uri.parse(_videoUrl));
    _controller.setVolume(_volume);
    _controller.setLooping(true);
    _controller.initialize().then((_) { setState(() {});});
    // _controller.initialize().then((_) { clickPlay(); });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Positioned(left: 0.w, right: 0.w, top: 0.w, bottom: 0.w,
            child: _controller.value.isInitialized ? Container(
              color: Colors.black,
              child: Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
            ) : Container(color: Colors.black,),
          ),
          Positioned(left: 0.w, right: 0.w, top: 0.w, bottom: 0.w,
            child: GestureDetector(
                onTap: () {
                  clickPlay();
                },
                child: Container(
                  color: Colors.transparent,
                  child: !_controller.value.isPlaying ? Icon(Icons.play_arrow_sharp, size: 100.w, color: const Color(0xAfffffff)) : Container(),
                )),
          )
        ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _videoUrl = widget.videoUrl;
    _volume = widget.volume;
    _controller.setVolume(_volume);
  }

  void clickPlay() {
    setState(() {
      if(!_controller.value.isPlaying) {
        _controller.play();
      } else {
        _controller.pause();
      }
    });
  }
}