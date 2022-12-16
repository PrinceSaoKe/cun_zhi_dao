import 'package:cun_zhi_dao/app_theme.dart';
import 'package:cun_zhi_dao/network_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoDetails extends StatefulWidget {
  const VideoDetails({super.key});

  @override
  State<VideoDetails> createState() => _VideoDetailsState();
}

class _VideoDetailsState extends State<VideoDetails> {
  String title = Get.arguments['title'];
  String url = Get.arguments['coverURL'];

  var duration;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        setState(() {});
      });

    _controller.addListener(() {
      setState(() {
        //进度条的播放进度，用当前播放时间除视频总长度得到
        duration = _controller.value.position.inSeconds /
            _controller.value.duration.inSeconds;

        if (_controller.value.position == _controller.value.duration) {
          print('结束播放');
          AppNetworkRequest.addCredit(10);
          Get.snackbar('积分已添加', '');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: AppTheme.appBarTitle)),
        centerTitle: true,
        backgroundColor: AppTheme.appBarBackground,
      ),
      backgroundColor: AppTheme.backgroundGrey,
      body: myBody(),
    );
  }

  myBody() {
    return Stack(
      children: [
        _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const Center(
                //视频加载时的圆型进度条
                child: CircularProgressIndicator(
                  strokeWidth: 4.0,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.appBarBackground,
                  ),
                ),
              ),

        //视频进度条
        if (_controller.value.isInitialized)
          Positioned(
            bottom: 5,
            child: LinearProgressIndicator(
              backgroundColor: Colors.grey,
              value: duration,
              valueColor: const AlwaysStoppedAnimation<Color>(
                  AppTheme.appBarBackground),
            ),
          ),

        // 播放暂停按钮
        Center(
          child: GestureDetector(
            onTap: () {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            },
            child:
                !_controller.value.isPlaying && _controller.value.isInitialized
                    ? const Icon(
                        Icons.play_arrow,
                        size: 70,
                        color: AppTheme.appBarBackground,
                      )
                    : null,
          ),
        ),
      ],
    );
  }
}
