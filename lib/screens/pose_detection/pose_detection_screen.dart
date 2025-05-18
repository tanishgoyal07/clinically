import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:scaitica/widgets/pose_prediction/pose_overlay.dart';
import 'package:video_player/video_player.dart';
import 'package:scaitica/utils/countdown_animation.dart';
import 'package:scaitica/utils/sound_player.dart';
import 'package:scaitica/services/prediction_services.dart';

class PoseDetectionScreen extends StatefulWidget {
  final String targetPose;

  const PoseDetectionScreen({super.key, required this.targetPose});

  @override
  _PoseDetectionScreenState createState() => _PoseDetectionScreenState();
}

class _PoseDetectionScreenState extends State<PoseDetectionScreen> {
  late CameraController cameraController;
  late VideoPlayerController videoController;

  bool isCameraInitialized = false;
  bool isVideoInitialized = false;
  bool showCountdown = true;
  bool isPoseCorrect = false;
  double confidence = 0.0;
  String predictedPose = "";
  bool isVideoFullScreen = false;

  @override
  void initState() {
    super.initState();
    _initializeResources();
  }

  Future<void> _initializeResources() async {
    await Future.wait([
      _initializeVideo(),
      _initializeCamera(),
    ]);
    _startCountdown();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        cameraController = CameraController(
          cameras.last,
          ResolutionPreset.medium,
          enableAudio: false,
        );
        await cameraController.initialize();
        setState(() {
          isCameraInitialized = true;
        });
      } else {
        throw Exception("No cameras available.");
      }
    } catch (e) {
      debugPrint("Error initializing camera: $e");
    }
  }

  Future<void> _initializeVideo() async {
    videoController = widget.targetPose == "balasana"
        ? VideoPlayerController.asset('assets/videos/balasana.mp4')
        : widget.targetPose == "vriksasana"
            ? VideoPlayerController.asset('assets/videos/vrikasana.mp4')
            : widget.targetPose == "ardha chandrasana"
                ? VideoPlayerController.asset(
                    'assets/videos/ardha_chandrasana.mp4')
                : widget.targetPose == "dhanurasana"
                    ? VideoPlayerController.asset(
                        'assets/videos/dhanurasana.mp4')
                    : widget.targetPose == "parighasana"
                        ? VideoPlayerController.asset(
                            'assets/videos/parighasana.mp4')
                        : VideoPlayerController.asset(
                            'assets/videos/utkasna.mp4')
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {
          isVideoInitialized = true;
        });
      }).catchError((error) {
        debugPrint("Error initializing video: $error");
      });
  }

  void _startCountdown() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      showCountdown = false;
      videoController.play();
    });
    startPoseDetection();
  }

  void startPoseDetection() async {
    while (isCameraInitialized && cameraController.value.isInitialized) {
      try {
        final frame = await cameraController.takePicture();
        final bytes = await frame.readAsBytes();

        final predictionResult =
            await PosePredictionService.predictPose(bytes, widget.targetPose);

        if (!mounted) return;

        setState(() {
          predictedPose = predictionResult['predicted_pose'];
          isPoseCorrect = predictionResult['is_correct'];
          confidence = predictionResult['confidence'];

          // if (predictionResult['alert']) {
          //   SoundPlayer.playSound('assets/sounds/alert.mp3');
          // }
        });
        await Future.delayed(const Duration(milliseconds: 1000));
      } catch (e) {
        print("Error during pose prediction: $e");
        break;
      }
    }
  }

  @override
  void dispose() {
    if (cameraController.value.isInitialized) {
      cameraController.dispose();
    }
    if (videoController.value.isInitialized) {
      videoController.dispose();
    }
    super.dispose();
  }

  void _toggleVideoView() {
    setState(() {
      isVideoFullScreen = !isVideoFullScreen;
    });
  }

  void _endExercise() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
            child: Text(
          'End Exercise',
        )),
        content: const Text(
          'Are you sure you want to end this exercise?',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text(
              'End',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        elevation: 0.0,
        title: Text(
          'Target Pose: ${widget.targetPose}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(10),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: _endExercise,
              child: const Text(
                'End Exercise',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          if (isVideoFullScreen ? isVideoInitialized : isCameraInitialized)
            Positioned.fill(
              child: isVideoFullScreen
                  ? VideoPlayer(videoController)
                  : CameraPreview(cameraController),
            )
          else
            const Center(child: CircularProgressIndicator()),
          if (isVideoFullScreen ? isCameraInitialized : isVideoInitialized)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: GestureDetector(
                  onTap: _toggleVideoView,
                  child: Container(
                    width: 150,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 5),
                      ],
                    ),
                    child: isVideoFullScreen
                        ? CameraPreview(cameraController)
                        : VideoPlayer(videoController),
                  ),
                ),
              ),
            ),
          if (showCountdown) Center(child: CountdownAnimation()),
          if (!showCountdown)
            PoseOverlay(
              isCorrect: isPoseCorrect,
              confidence: confidence,
              predictedPose: predictedPose,
              targetPose: widget.targetPose,
            ),
        ],
      ),
    );
  }
}
