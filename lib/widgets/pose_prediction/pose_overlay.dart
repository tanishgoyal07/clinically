import 'package:flutter/material.dart';

class PoseOverlay extends StatelessWidget {
  final bool isCorrect;
  final double confidence;
  final String predictedPose;
  final String targetPose;

  const PoseOverlay({
    required this.isCorrect,
    required this.confidence,
    required this.predictedPose,
    required this.targetPose,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Card(
          //   color: Colors.black.withOpacity(0.6),
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   elevation: 8,
          //   child: Padding(
          //     padding: const EdgeInsets.all(12.0),
          //     child: Text(
          //       'Target Pose: $targetPose',
          //       textAlign: TextAlign.center,
          //       style: const TextStyle(
          //         fontSize: 16,
          //         fontWeight: FontWeight.bold,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 10),
          // // Pose Status Card
          Card(
            color: isCorrect ? Colors.green.withOpacity(0.8) : Colors.red.withOpacity(0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                isCorrect
                    ? 'Correct Pose'
                    : 'Wrong Pose\nPredicted: $predictedPose',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(
              'Confidence: ${confidence.toStringAsFixed(2)}%',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
