import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app.dart';

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
  // Add any async initialization here
}
