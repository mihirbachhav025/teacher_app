import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:teacher_app/controllers/MapController.dart';

import '../models/lecture.dart';

class MapSample extends StatefulWidget {
  final Lecture lecture;
  const MapSample({Key? key, required this.lecture}) : super(key: key);
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    final Lecture lecture = widget.lecture;
    final MapController mapController = Get.put(MapController(lecture));
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Students"),
      ),
      body: Obx(() {
        if (mapController.loadingDone.value == false) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * .75,
                child: Scrollbar(
                    radius: const Radius.circular(25),
                    thickness: 6,
                    thumbVisibility: true,
                    trackVisibility: true,
                    child: ListView(
                      children: List.generate(mapController.documentIds.length,
                          (index) {
                        bool isPresent = false;
                        if (mapController.studentPresence
                            .containsKey(mapController.documentIds[index])) {
                          isPresent = mapController.studentPresence[
                              mapController.documentIds[index]]["isThere"];
                        }
                        return Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: ListTile(
                            key: ValueKey(index),
                            trailing: CircleAvatar(
                              radius: 8,
                              backgroundColor:
                                  isPresent ? Colors.green : Colors.red,
                            ),
                            title: Text(
                              ' ${mapController.documentIds[index]}',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                      }),
                    )),
              ),
              if (!mapController.documentIds.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                      width: MediaQuery.of(context).size.width * .50,
                      height: MediaQuery.of(context).size.height * .05,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      child: const Text("Mark Attendance"),
                      onPressed: () {
                        mapController.markAttendance();
                      },
                    ),
                  ),
                ),
            ],
          );
        }
      }),
    );
  }
}
