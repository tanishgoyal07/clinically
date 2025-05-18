import 'package:flutter/material.dart';
import 'package:scaitica/screens/pose_detection/pose_detection_screen.dart';
import 'package:scaitica/screens/pose_detection/workout_mode_screen.dart';
import 'package:scaitica/utils/pose_list.dart';
import 'package:scaitica/widgets/posecard.dart'; // Assuming poseNames are coming from here

class PoseSelectionScreen extends StatefulWidget {
  @override
  _PoseSelectionScreenState createState() => _PoseSelectionScreenState();
}

class _PoseSelectionScreenState extends State<PoseSelectionScreen> {
  List<String> filteredPoses = poseNames;
  TextEditingController searchController = TextEditingController();

  void filterPoses(String query) {
    final filtered = poseNames
        .where((pose) => pose.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredPoses = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Select Exercise Pose",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 23,
                  ),
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.only(top: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  borderSide: BorderSide(
                    color: Colors.black38,
                    width: 1,
                  ),
                ),
                hintText: 'Search Poses',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
              ),
              onChanged: filterPoses,
            ),
          ),
          Expanded(
              child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 8,
              childAspectRatio: 0.8,
            ),
            itemCount: filteredPoses.length,
            itemBuilder: (context, index) {
              final pose = filteredPoses[index];
              return PoseCard(
                poseName: pose,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => WorkoutModeScreen(
                        targetPose: pose,
                      ),
                    ),
                  );
                },
              );
            },
          )),
        ],
      ),
    );
  }
}
