import 'dart:convert';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:scaitica/screens/pose_detection/pose_detection_screen.dart';
import 'package:scaitica/utils/constant.dart';
import 'package:video_player/video_player.dart';

class WorkoutModeScreen extends StatefulWidget {
  final String targetPose;

  const WorkoutModeScreen({super.key, required this.targetPose});

  @override
  State<WorkoutModeScreen> createState() => _WorkoutModeScreenState();
}

class _WorkoutModeScreenState extends State<WorkoutModeScreen> {
  File? _selectedVideo;
  File? _outputVideo;
  VideoPlayerController? _controller;
  bool isAnalyzing = false;

  Future<void> pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      setState(() {
        _selectedVideo = File(result.files.single.path!);
        _outputVideo = null;
      });
    }
  }

  Future<void> uploadAndAnalyze() async {
    if (_selectedVideo == null) return;
    setState(() => isAnalyzing = true);

    var uri = Uri.parse(VIDEO_ANALYZER_URI);
    final request = http.MultipartRequest('POST', uri)
      ..fields['pose'] = widget.targetPose
      ..files.add(
          await http.MultipartFile.fromPath('video', _selectedVideo!.path));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final bytes = await response.stream.toBytes();
        final dir = await getTemporaryDirectory();
        final file = File("${dir.path}/output.mp4");
        await file.writeAsBytes(bytes);

        setState(() {
          _outputVideo = file;
          _controller = VideoPlayerController.file(file)
            ..initialize().then((_) => setState(() {}));
        });
      } else {
        var errorText = await response.stream.bytesToString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error analyzing video: $errorText")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exception: $e")),
      );
    }

    setState(() => isAnalyzing = false);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Select Workout Mode",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PoseDetectionScreen(
                          targetPose: widget.targetPose,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.sports_gymnastics,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Do Live Workout - ${widget.targetPose}",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Center(
                  child: Text(
                    "OR",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Analyze Your Workout Video Of",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  widget.targetPose,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DottedBorder(
                  color: Colors.grey,
                  strokeWidth: 2,
                  dashPattern: const [6, 4],
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  child: InkWell(
                    onTap: pickVideo,
                    child: Container(
                      height: 160,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: _selectedVideo == null
                          ? const Text(
                              "📎 Tap or drag here to upload video",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.insert_drive_file,
                                    size: 40, color: Colors.blueAccent),
                                SizedBox(height: 8),
                                Text(
                                  "1 file selected",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: _selectedVideo == null || isAnalyzing
                      ? null
                      : uploadAndAnalyze,
                  icon: const Icon(
                    Icons.analytics,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Analyze My Video",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                if (isAnalyzing)
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(
                              "Take deep breaths, while we are analyzing your workout...",
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              speed: const Duration(milliseconds: 80),
                            ),
                          ],
                          totalRepeatCount: 20,
                          pause: const Duration(milliseconds: 500),
                          displayFullTextOnTap: true,
                          stopPauseOnTap: true,
                        ),
                      ],
                    ),
                  ),

                if (_outputVideo != null &&
                    _controller != null &&
                    _controller!.value.isInitialized) ...[
                  const Text(
                    "Here's your analysis",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _controller!.value.isPlaying
                            ? _controller!.pause()
                            : _controller!.play();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              VideoPlayer(_controller!),
                              if (!_controller!.value.isPlaying)
                                Container(
                                  color: Colors.black45,
                                  child: const Icon(
                                    Icons.play_circle_fill,
                                    color: Colors.white,
                                    size: 64,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                // if (isAnalyzing) const CircularProgressIndicator(),
                // if (_outputVideo != null &&
                //     _controller != null &&
                //     _controller!.value.isInitialized) ...[
                //   const Text("Here's your analysis",
                //       style:
                //           TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                //   const SizedBox(height: 10),
                //   AspectRatio(
                //     aspectRatio: _controller!.value.aspectRatio,
                //     child: VideoPlayer(_controller!),
                //   ),
                //   if (_controller != null && _controller!.value.isInitialized)
                //     ElevatedButton(
                //       onPressed: () => setState(() =>
                //           _controller!.value.isPlaying
                //               ? _controller!.pause()
                //               : _controller!.play()),
                //       child: Icon(_controller!.value.isPlaying
                //           ? Icons.pause
                //           : Icons.play_arrow),
                //     ),
                // ],
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ));
  }
}
