// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Project imports:
import '../bindings/initial_binding.dart';
import '../views/home_view.dart';
import '../views/library_view.dart';
import '../views/manage_term_view.dart';
import '../views/translate_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Digital Jahai",
          // You can use the library anywhere in the app even in theme
          theme: ThemeData(
            // primarySwatch: Colors.blue,
            fontFamily: 'Poppins',
            // textTheme: Typography.blackCupertino.apply(fontSizeFactor: 1.sp),
            
          ),
          home: child,
          initialBinding: InitialBinding(),
          getPages: [
            GetPage(name: '/', page: () => HomeView()),
            GetPage(name: '/translate', page: () => TranslateView()),
            GetPage(name: '/library', page: () => LibraryView()),
            GetPage(name: '/manage-term', page: () => ManageTermView())
          ],
          initialRoute: '/',
        );
      },
      child: HomeView(),
    );
  }
}
