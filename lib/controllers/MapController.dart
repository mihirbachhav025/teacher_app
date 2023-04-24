import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:to_csv/to_csv.dart' as exportCSV;

import '../models/lecture.dart';
import '../screens/teacher_view_attendance_page.dart';

class MapController extends GetxController {
  RxBool loadingDone = false.obs;
  late final Lecture lecture;
  final RxList documentIds = [].obs;
  final RxMap studentPresence = {}.obs;
  final studentAttendance = {};
  final Geolocator geolocator = Geolocator();
  Logger logger = Logger();
  late DateTime dt;

  late StreamSubscription _subscription;
  final databaseReference = FirebaseDatabase.instance.ref();
  MapController(this.lecture);

  @override
  void onInit() async {
    super.onInit();
    _fetchStudentLocation();
  }

  //main controller function that fetchs data from firebase and firestore
  void _fetchStudentLocation() async {
    logger.d(lecture.path + "nishanttttttttttt");
    final collectionRef = FirebaseFirestore.instance.collection(lecture.path);
    final querySnapshot = await collectionRef.get();

    // Loop through the querySnapshot to get the IDs of all the documents
    for (var doc in querySnapshot.docs) {
      documentIds.add(doc.id);
      studentPresence[doc.id] = {
        "isThere": false
      }; // Initialize student presence as false
      _listenToDataStream(doc.id);
    }
    loadingDone.value = true;
  }

  void markAttendance() {
    for (var docid in documentIds) {
      studentAttendance.addAll({docid: false});
      if (studentPresence.containsKey(docid)) {
        // var latitude = studentPresence[docid]["latitude"];
        // var longitude = studentPresence[docid]["longitude"];
        // final distanceInMeters = Geolocator.distanceBetween(
        //     latitude, longitude, 19.029680819221838, 73.0164371494602);
        // if (distanceInMeters < 75) {
        //   studentAttendance[docid] = true;
        //   final collectionRef =
        //       FirebaseFirestore.instance.collection(lecture.path);
        //   await collectionRef.doc(docid).update({'status': true});
        // }
        studentAttendance[docid] = studentPresence[docid]["isThere"];
      }
    }
    Get.to(ViewAttendance());
  }

  Future<void> saveAttendance() async {
    final collectionRef = FirebaseFirestore.instance.collection(lecture.path);
    for (var key in studentAttendance.keys) {
      logger.d(studentAttendance[key].toString() + " " + key.toString());
      if (studentAttendance[key] == true) {
        await collectionRef.doc(key).update({'status': true});
      }
    }
  }

  Future<void> downloadAttendance() async {
    List<String> header = [];
    header.add('ID. ');
    header.add('Status');
    List<List<String>> listOfLists = [];
    final collectionRef = FirebaseFirestore.instance.collection(lecture.path);
    for (var key in studentAttendance.keys) {
      logger.d(studentAttendance[key].toString() + " " + key.toString());
      if (studentAttendance[key] == true) {
        await collectionRef.doc(key).update({'status': true});
      }
      List<String> data1 = [key.toString(), studentAttendance[key].toString()];
      listOfLists.add(data1);
    }
    exportCSV.myCSV(header, listOfLists);
  }

  void _listenToDataStream(String docId) {
    _subscription = databaseReference.child(docId).onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> values =
            event.snapshot.value as Map<dynamic, dynamic>;
        String docIdstr = docId.toString();
        final distanceInMeters = Geolocator.distanceBetween(values["latitude"],
            values["longitude"], 19.029680819221838, 73.0164371494602);
        bool isThere = false;
        if (distanceInMeters < 75) {
          isThere = true;
        }
        dt = DateTime.fromMicrosecondsSinceEpoch(values["timestamp"]);
        Timestamp t11 = values["timestamp"];

        Timestamp t21 = Timestamp.now();
        logger.d(t21.toDate());
        Duration difference = DateTime.now().difference(dt);
        // code to compare timestamps
        // if (difference.inMinutes > 45) {
        //   isThere = false;
        // }
        Map<String, dynamic> studentData = {
          "isThere": isThere, // add the initial value of false to the map
          ...values, // spread the location data into the map
        };
        studentPresence.update(docIdstr, (value) => studentData);
        update(["studentPresence"]);
        // add the map to the studentPresence map
      }
    });
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
