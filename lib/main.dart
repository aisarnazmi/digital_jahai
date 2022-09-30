// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Project imports:
import '../bindings/initial_binding.dart';
import '../views/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    //Set the fit size (fill in the screen size of the device in the design) If the design is based on the size of the iPhone6 ​​(iPhone6 ​​750*1334)

    // return ScreenUtilInit(
    //   designSize: const Size(390, 844),
    //   minTextAdapt: true,
    //   splitScreenMode: true,
    //   builder: (BuildContext c) => MaterialApp(
    //     title: "Digital Jahai",
    //     debugShowCheckedModeBanner: false,
    //     builder: (context , child) {
    //       ScreenUtil.setContext(context);
    //       return MediaQuery(
    //         //Setting font does not change with system font size
    //         data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
    //         child: widget as Widget,
    //       );
    //     },
    //     home: HomeView(),
    //     initialBinding: InitialBinding(),
    //   ),
    // );

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context , child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Digital Jahai",
          // You can use the library anywhere in the app even in theme
          theme: ThemeData(
            // primarySwatch: Colors.blue,
            textTheme: Typography.blackCupertino.apply(fontSizeFactor: 1.sp),
          ),
          home: child,
        initialBinding: InitialBinding(),
        );
      },
      child: const HomeView(),
    );
  }
}
