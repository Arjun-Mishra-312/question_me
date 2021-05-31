import 'dart:io';
import 'dart:async';
import 'dart:math' as math;
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:question_me/questions.dart';
import 'package:question_me/response_screen.dart';
import 'package:video_player/video_player.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.text}) : super(key: key);

  final String? text;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isVideo = false;
  VideoPlayerController? _controller;
  VideoPlayerController? _toBeDisposed;
  String? _retrieveDataError;
  List<PickedFile> answers = [];

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

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
      // final double volume = kIsWeb ? 0.0 : 1.0;
      // await controller.setVolume(volume);
      // await controller.initialize();
      // await controller.setLooping(false);
      // await controller.play();
      setState(() {_currentPage == 5 ? _currentPage = _currentPage - 1 : _currentPage = _currentPage;});
    }
  }

  void _onImageButtonPressed(ImageSource source) async {
    if (_controller != null) {
      await _controller!.setVolume(0.0);
    }
    if (isVideo) {
      final PickedFile? file = await _picker.getVideo(
          source: source,
          maxDuration: const Duration(seconds: 30),
          preferredCameraDevice: CameraDevice.front);
      await _playVideo(file);
      if (file != null) {
        answers.add(file);
        print("this the answers file check if this is working $answers");
      }
    }
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller!.setVolume(0.0);
      _controller!.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _disposeVideoController();
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

  Future<void> _disposeVideoController() async {
    if (_toBeDisposed != null) {
      await _toBeDisposed!.dispose();
    }
    _toBeDisposed = _controller;
    _controller = null;
  }

  Widget _previewVideo() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_controller == null) {
      return Text(
        'You have not yet recorded a video',
        style: GoogleFonts.robotoMono(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(252, 168, 10, 1.0)),
      );
    }
    return Center(
      child: Text(
        'Your response has been recorded',
        style: TextStyle(
            fontWeight: FontWeight.w500, color: Colors.greenAccent.shade700),
      ),
    );
    // Padding(
    //   padding: const EdgeInsets.all(10.0),
    //   child: AspectRatioVideo(_controller),
    // );
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.video) {
        isVideo = true;
        await _playVideo(response.file);
      }
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  int _currentPage = 0;
  PageController _pageController = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 45), (Timer timer) {
      if (_currentPage < 5) {
        _currentPage++;
      } else {
        _currentPage = _currentPage;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  List<String> ques = flutterQuestions;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.orangeAccent.shade100,
      statusBarColor: Colors.blueAccent.shade700,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    ));
    print(widget.text);
    String txt = ques[_currentPage];
    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (_) {
            setState(() {
              _controller = null;
            });
            print(_currentPage);
            print(answers);
          },
          physics: NeverScrollableScrollPhysics(),
          children: List<Widget>.generate(5, (_) {
            return Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.5, 1.0],
                    colors: [
                      Colors.blueAccent.shade700,
                      Colors.orangeAccent.shade100
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "Questions",
                          style: GoogleFonts.robotoMono(
                              fontSize: 23, color: Colors.white),
                        ),
                      ),
                      Container(
                        height: 300,
                        margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
                        // padding: EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.grey.shade700,
                          //     blurRadius: 15.0, // soften the shadow
                          //     spreadRadius: 1.0, //extend the shadow
                          //     offset: Offset(
                          //       2.0, // Move to right 10  horizontally
                          //       2.0, // Move to bottom 10 Vertically
                          //     ),
                          //   ),
                          //   BoxShadow(
                          //     color: Colors.grey.shade700,
                          //     blurRadius: 25.0, // soften the shadow
                          //     spreadRadius: 3.0, //extend the shadow
                          //     offset: Offset(
                          //         -4.0, // Move to right 10  horizontally
                          //         -4.0 // Move to bottom 10 Vertically
                          //         ),
                          //   )
                          // ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              txt,
                              style: GoogleFonts.robotoMono(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.1),
                            ),
                            _previewVideo(),
                            _currentPage == ques.length - 1
                                ? ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ResponseScreen(
                                            response: answers,
                                            controller: _controller,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text('view your responses',
                                        style:
                                            GoogleFonts.robotoMono(fontSize: 15)))
                                : Container(),
                          ],
                        ),
                      ),
                      CircularCountDownTimer(
                        duration: 45,
                        initialDuration: 0,
                        controller: CountDownController(),
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.height / 2,
                        ringColor: Colors.grey[300]!,
                        ringGradient: null,
                        fillColor: Colors.greenAccent,
                        fillGradient: SweepGradient(
                          startAngle: 2.97 * math.pi / 2,
                          endAngle: 7 * math.pi / 2,
                          tileMode: TileMode.repeated,
                          colors: [
                            Colors.greenAccent,
                            Colors.yellow,
                            Colors.redAccent
                          ],
                        ),
                        backgroundColor: Colors.transparent,
                        backgroundGradient: null,
                        strokeWidth: 10.0,
                        strokeCap: StrokeCap.round,
                        textStyle: TextStyle(
                            fontSize: 33.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        textFormat: CountdownTextFormat.S,
                        isReverse: false,
                        isReverseAnimation: false,
                        isTimerTextShown: true,
                        autoStart: true,
                        onStart: () {
                          print('Countdown Started');
                        },
                        onComplete: () {
                          print('Countdown Ended');
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () {
                  isVideo = true;
                  _onImageButtonPressed(ImageSource.camera);
                },
                heroTag: 'video1',
                tooltip: 'Take a Video',
                child: const Icon(Icons.videocam),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}
