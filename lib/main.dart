import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:panda_music/constant/app_color.dart';
import 'package:panda_music/constant/app_constant.dart';
import 'package:panda_music/demo.dart';
import 'package:panda_music/view/splash_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'hive_model/download_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(DownloadModelAdapter());
  Hive.openBox<DownloadModel>(AppConstant.downloadBox);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Panda',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: AppColor.blue,
            unselectedWidgetColor: AppColor.lightPurple,
            appBarTheme: AppBarTheme(color: AppColor.blue, elevation: 0),
          ),
          home: SplashScreen(),
          // home: FilePickers(),
        );
      },
    );
  }
}

/// Keyboard Close On Tap Of Button
/*
FocusScopeNode currentFocus = FocusScope.of(context);
if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
currentFocus.focusedChild!.unfocus();
}*/

/// Hive Model Generator Command
// $ flutter packages pub run build_runner build
