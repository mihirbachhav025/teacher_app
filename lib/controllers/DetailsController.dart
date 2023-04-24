import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:teacher_app/utils/sharepref.dart';

class DetailsController extends GetxController {
  Dio dio = Dio();
  Logger logger = Logger();
  RxString firstName = ''.obs;
  RxString lastName = ''.obs;

  void onInit() {
    fetchDetails();
    super.onInit();
  }

  Future<String> fetchDetails() async {
    try {
      String token = SharedPrefs.getIdentityToken()!;
      dio.options.headers["Authorization"] = "Bearer $token";
      final response = await dio.get(
        'https://attendance-app-production.up.railway.app/api/v1/professors/getDetails',
      );
      if (response.statusCode == 200) {
        var _jsonData = response.data as Map<String, dynamic>;
        logger.d('Checking profeesor details');
        var profData = <String, String>{};
        for (var key in _jsonData.keys) {
          if (_jsonData[key] == null) {
            profData[key] = '';
          } else {
            profData[key] = _jsonData[key].toString();
          }
        }

        firstName.value = profData['Firstname']!;
        update();
        return profData['Firstname']! + " " + profData['Lastname']!;
      } else {
        return '';
      }
    } catch (e) {
      throw Exception('Failed to connect to backend server: $e');
    }
  }
}
