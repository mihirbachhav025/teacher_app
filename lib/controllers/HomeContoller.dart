// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dio/dio.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:logger/logger.dart';

// import '../../utils/sharepref.dart';
// import '../models/lecture.dart';

// class HomeController extends GetxController {
//   RxBool isLoading = RxBool(true);
//   Dio dio = Dio();
//   Logger logger = Logger();

//   void onInit() {
//     super.onInit();
//     _fetchLectureData();
//   }

//   void _fetchLectureData() async {
//     try {
//       String token = SharedPrefs.getIdentityToken()!;
//       dio.options.headers["Authorization"] = "Bearer $token";

//       // Get the current day of the week as a lowercase string
//       String today = DateFormat('EEEE').format(DateTime.now()).toLowerCase();

//       // Pass the current day in the request body
//       final response = await dio.post(
//         'http://localhost:3000/api/v1/professors/getLectures',
//         data: {'today': today},
//       );

//       // Check if the API call was successful
//       if (response.statusCode == 200) {
//         // Parse the lectures from the response
//         List<dynamic> lecturesJson = response.data["lectures"];
//         logger.d(lecturesJson);
//         List<Lecture> lectures = (lecturesJson as List)
//             .map((lectureJson) =>
//                 Lecture.fromJson(Map<String, dynamic>.from(lectureJson)))
//             .toList();
//         logger.d('List of Lectures:');
//         for (Lecture lecture in lectures) {
//           logger.d(lecture.toString());
//         }

//         // Do something with the lectures
//         // ...
//       } else {
//         // Handle the error
//         throw Exception('Failed to load lectures');
//       }
//     } catch (e) {
//       throw Exception('Failed to connect to backend server: $e');
//       // Handle any errors
//     } finally {
//       // Do any necessary cleanup or processing
//     }
//   }
// }
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

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
      String token = SharedPrefs.getIdentityToken()!;
      dio.options.headers["Authorization"] = "Bearer $token";

      // Get the current day of the week as a lowercase string
      String today = DateFormat('EEEE').format(DateTime.now()).toLowerCase();

      // Pass the current day in the request body
      final response = await dio.post(
        'http://localhost:3000/api/v1/professors/getLectures',
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
        for (Lecture lecture in lectures) {
          logger.d(lecture.toString());
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
}
