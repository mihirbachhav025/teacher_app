import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get/get.dart';
import 'package:teacher_app/models/lecture.dart';

import '../controllers/MapController.dart';

class ViewAttendance extends StatefulWidget {
  const ViewAttendance({
    Key? key,
  }) : super(key: key);

  @override
  State<ViewAttendance> createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<ViewAttendance> {
  @override
  Widget build(BuildContext context) {
    final MapController mapController = Get.find<MapController>();
    return ProgressHUD(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Mark Attendance"),
        ),
        body: ProgressHUD(child: Builder(builder: ((context) {
          return Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * .70,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: mapController.studentAttendance.length,
                  itemBuilder: (context, index) {
                    // Get the key and value of the map entry at the current index
                    final entry = mapController.studentAttendance.entries
                        .elementAt(index);
                    final studentId = entry.key;
                    bool isPresent = entry.value;

                    return CheckboxListTile(
                      value: isPresent,
                      onChanged: (newValue) {
                        setState(() {
                          // Update the map entry with the new value
                          isPresent = newValue!;
                          mapController.studentAttendance[studentId] =
                              isPresent;
                        });
                      },
                      title: Text(studentId),
                    );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        final progress = ProgressHUD.of(context);
                        progress?.showWithText('Saving Attendance...');
                        await mapController.saveAttendance();
                        progress?.dismiss();
                      },
                      child: Text("Save Attendance"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final progress = ProgressHUD.of(context);
                        progress?.showWithText('Downloading Attendance...');
                        await mapController.downloadAttendance();
                        progress?.dismiss();
                      },
                      child: Text("Download Attendance"),
                    ),
                  ],
                ),
              ),
            ],
          );
        }))),
      ),
    );
  }
}
