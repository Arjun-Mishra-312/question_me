import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:question_me/video_player.dart';
import 'package:video_player/video_player.dart';

class ResponseScreen extends StatefulWidget {
  final List<PickedFile>? response;

  final VideoPlayerController? controller;

  ResponseScreen({this.response, this.controller});

  @override
  _ResponseScreenState createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
  VideoPlayerController? _controller;
  VideoPlayerController? _toBeDisposed;

  Future<void> _playVideo(PickedFile? file) async {
    if (file != null && mounted) {
      await _disposeVideoController();
      late VideoPlayerController controller;
      if (kIsWeb) {
        controller = VideoPlayerController.network(file.path);
      } else {
        controller = VideoPlayerController.file(File(file.path));
      }
      _controller = controller;
      final double volume = kIsWeb ? 0.0 : 1.0;
      await controller.setVolume(volume);
      await controller.initialize();
      await controller.setLooping(false);
      await controller.play();
      setState(() {});
    } else {
      setState(() {
        _controller = null;
      });
    }
  }

  @override
  void dispose() {
    _disposeVideoController();
    super.dispose();
  }

  Future<void> _disposeVideoController() async {
    if (_toBeDisposed != null) {
      await _toBeDisposed!.dispose();
    }
    _toBeDisposed = _controller;
    _controller = null;
  }

  Widget video(int i) {
    if (_controller != null) {
      return Column(
        children: [
          Text("These are your responses"),
          AspectRatioVideo(_controller)
        ],
      );
    } else {
      _playVideo(widget.response![0]);
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  int _currentPage = 0;
  PageController pagecontroller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    // PickedFile ans = widget.response![_currentPage];
    print(
        'This is the respones from the response screen and it should show somehting${widget.response![0]}');
    print('This os the controlleer responese ples check${widget.controller}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Response'),
      ),
      body: PageView(
          controller: pagecontroller,
          onPageChanged: (_) {
            setState(() {
              _currentPage = _currentPage + 1;
              _controller = null;
            });
          },
          children: List<Widget>.generate(
            5,
            (_) {
              return video(
                _currentPage,
              );
            },
          )),
    );
  }
}
