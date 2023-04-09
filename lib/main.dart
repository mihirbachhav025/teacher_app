import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacher_app/screens/login_page.dart';
import 'controllers/bindings/HomeBinding.dart';
import 'controllers/bindings/LoginBinding.dart';
import 'screens/HomeScreen.dart';
import 'utils/sharepref.dart';
import 'firebase_options.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logger/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPrefs.init();
  //below committed code was for student app
  // Get.put<LocationService>(LocationService(), permanent: true);
  // Get.put(LocationController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  String returnRoute() {
    final String? x = SharedPrefs.getIdentityToken();
    if (x != null && x.length != 0 && !JwtDecoder.isExpired(x)) {
      Logger logger = Logger();
      logger.d('=========Identity token here==========');
      logger.d("${SharedPrefs.getIdentityToken()}");
      logger.d(x.length);
      logger.d('====================');
      return '/homeScreen';
    }
    return '/login';
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'NextGen Attendance Student',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: returnRoute(),
      getPages: [
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
          binding: LoginBinding(),
        ),
        GetPage(
          name: '/homeScreen',
          page: () => HomeScreen(),
          binding: HomeBinding(),
        ),
      ],
    );
  }
}
