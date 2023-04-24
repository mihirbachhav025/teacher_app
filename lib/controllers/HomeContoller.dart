import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:teacher_app/controllers/DetailsController.dart';

import '../../utils/sharepref.dart';
import '../models/lecture.dart';

class HomeController extends GetxController {
  RxBool isLoading = RxBool(true);
  Dio dio = Dio();
  Logger logger = Logger();
  RxList<Lecture> lectures = RxList<Lecture>([]);

  void onInit() {
    super.onInit();
    _fetchLectureData();
  }

  void _fetchLectureData() async {
    isLoading.value = true;
    try {
      DetailsController detailsController = Get.put(DetailsController());
      String token = SharedPrefs.getIdentityToken()!;
      dio.options.headers["Authorization"] = "Bearer $token";
      String currentyear = getYearString();
      String todaysDate = getTodayDate();
      late String profName;
      // Get the current day of the week as a lowercase string
      String today = DateFormat('EEEE').format(DateTime.now()).toLowerCase();

      // Pass the current day in the request body
      final response = await dio.post(
        'https://attendance-app-production.up.railway.app/api/v1/professors/getLectures',
        data: {'today': today},
      );

      // Check if the API call was successful
      if (response.statusCode == 200) {
        // Parse the lectures from the response
        List<dynamic> lecturesJson = response.data["lectures"];
        logger.d(lecturesJson);
        lectures.value = (lecturesJson as List)
            .map((lectureJson) =>
                Lecture.fromJson(Map<String, dynamic>.from(lectureJson)))
            .toList();
        logger.d('List of Lectures:');
        try {
          logger.d("jelllly beanssss");
          profName = SharedPrefs.getUserId()! +
              "-" +
              await detailsController.fetchDetails();
          logger.d(profName);
        } catch (e) {
          throw Exception('Failed to connect to backend server: $e');
        }
        for (Lecture lecture in lectures) {
          final collectionRef = FirebaseFirestore.instance
              .collection(currentyear)
              .doc(lecture.cName)
              .collection(lecture.academicYear)
              .doc(lecture.division)
              .collection(todaysDate)
              .doc(profName)
              .collection(lecture.subName);
          final QuerySnapshot querySnapshot =
              await collectionRef.limit(1).get();
          if (querySnapshot.size > 0) {
            logger.d(collectionRef.path + "omkarrrrrrrrrr");
            lecture.path = collectionRef.path;
          } else {
            lectures.remove(lecture);
          }
          // //code to check if path exits
        }

        isLoading.value = false;
      } else {
        // Handle the error
        throw Exception('Failed to load lectures');
      }
    } catch (e) {
      throw Exception('Failed to connect to backend server: $e');
      // Handle any errors
    } finally {
      isLoading.value = false;
      // Do any necessary cleanup or processing
    }
  }

  String getYearString() {
    DateTime now = DateTime.now();
    if (now.month < 6) {
      return '${now.year - 1}-${now.year}';
    } else {
      return '${now.year}-${now.year + 1}';
    }
  }

  String getTodayDate() {
    DateTime now = DateTime.now();
    String formattedDate =
        "${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}-${now.year.toString()}";
    return formattedDate;
  }
}
