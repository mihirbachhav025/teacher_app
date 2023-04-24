import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:teacher_app/controllers/DetailsController.dart';
import 'package:teacher_app/screens/teacher_map_page.dart';

import '../controllers/HomeContoller.dart';
import '../controllers/LoginController.dart';
import '../models/lecture.dart';
import '../utils/sharepref.dart';

class HomeScreen extends StatefulWidget {
  //final Future<String> value;
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool light0 = false;

  @override
  Widget build(BuildContext context) {
    final HomeController _controller = Get.put(HomeController());
    final DetailsController _detailController = Get.put(DetailsController());
    String userId = SharedPrefs.getUserId()!;
    Logger logger = Logger();
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Attendance')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: const Text(
              'Today\'s Lectures',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Obx(
            () {
              if (_controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else {
                List<Lecture> lectures = _controller.lectures;
                return Expanded(
                  child: ListView.builder(
                    itemCount: lectures.length,
                    itemBuilder: (context, index) {
                      Lecture lecture = lectures[index];
                      return InkWell(
                        splashColor: Colors.pinkAccent,
                        onTap: () {
                          Get.to(MapSample(
                            lecture: lecture,
                          ));
                        },
                        child: Card(
                          color: const Color.fromARGB(255, 235, 173, 228),
                          margin: const EdgeInsets.all(8),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${lecture.subName}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${lecture.cName}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Room Number: ${lecture.roomNo}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Division: ${lecture.division}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Academic Year: ${lecture.academicYear}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Semester: ${lecture.sem}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Day: ${lecture.day}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Start Time: ${lecture.startTime}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'End Time: ${lecture.endTime}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              currentAccountPicture: Image.network(
                  'https://th.bing.com/th?id=ODL.b888a41f9a8eb720963897b5e5430fc1&w=100&h=100&c=12&pcl=faf9f7&o=6&dpr=1.3&pid=13.1'),
              accountName: Obx(() => Text(_detailController.firstName.value)),
              accountEmail: Text(userId),
              // accountName: Text(
              //     'Welcome  ${studentDataController.studentData['Firstname']} ${studentDataController.studentData['Lastname']} \n  '),
              // accountEmail: Text(
              //     'Division :${studentDataController.studentData['Division']}  Rollno: ${studentDataController.studentData['RollNo']}'),
            ),
            ListTile(
              title: const Text('View Timetable'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('View Attendance'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                final loginController = Get.find<LoginController>();
                await loginController.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
