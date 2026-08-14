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

//  {
//             "id": 12,
//             "date": "2026-08-13",
//             "completed": "pending",
//             "metric_value": 5.0,
//             "logged_metrics": {},
//             "notes": "",
//             "daily_observation": "",
//             "ai_suggestion": "Spend 15 focused minutes working on a task tonight to test your night productivity.",
//             "created_at": "2026-08-13T09:41:48.594077Z"
//         }