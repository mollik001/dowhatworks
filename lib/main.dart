import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'app.dart';

import 'app/data/services/storage_service.dart';
import 'app/data/services/user_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initAppDependencies();
  runApp(
    ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return const DoWhatWorksApp();
      },
    ),
  );
}

Future<void> initAppDependencies() async {
  await StorageService.init();
  Get.put<UserService>(UserService(), permanent: true);
}

/*

Concerns:

Forget pass not sending OTP.
Onboarding game.
`
 */

