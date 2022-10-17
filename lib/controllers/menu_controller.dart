// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import '../constants/color.dart';

class MenuController extends GetxController {
  var isDrawerOpen = false.obs;
  var isDragging = false.obs;

  var xOffsetMain = 0.0.obs;
  var yOffsetMain = 0.0.obs;
  var scaleFactorMain = 1.0.obs;
  var scaleFactorDrawer = 0.1.obs;

  late GetStorage box;

  var isFirstTime = true;

  @override
  void onInit() async {
    super.onInit();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    await GetStorage.init();
    box = GetStorage();
    if (box.read('firsttime') != null) {
      isFirstTime = box.read('firsttime');
    }
  }

  @override
  void onReady() {
    super.onReady();

    Future.delayed(Duration(milliseconds: 1000), () {
      if (isFirstTime) {
        showCupertinoModalBottomSheet(
            context: Get.context as BuildContext,
            backgroundColor: colorBackgroundLight,
            isDismissible: false,
            builder: (context) => keyboardDialogModal());
      }
    });
  }

  void openDrawer() {
    xOffsetMain.value = 240;
    yOffsetMain.value = 180;
    scaleFactorMain.value = 0.7;
    scaleFactorDrawer.value = 1;
    isDrawerOpen.value = true;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  void closeDrawer() {
    xOffsetMain.value = 0;
    yOffsetMain.value = 0;
    scaleFactorMain.value = 1;
    scaleFactorDrawer.value = 0.1;
    isDrawerOpen.value = false;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }

  Future onOpenUrl(LinkableElement link) async {
    var url = Uri.parse(link.url);

    if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $link';
    }
  }

  Widget keyboardDialogModal() {
    return Material(
        child: SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(25.0.w, 10.0.h, 25.0.w, 20.0.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Install IPA Keyboard",
                      style: TextStyle(
                          color: colorTextDark,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600)),
                  IconButton(
                      onPressed: () {
                        box.write('firsttime', false);
                        Get.back();
                      },
                      icon: Icon(Icons.close)),
                ],
              ),
              SizedBox(
                height: 20.0.h,
              ),
              Text(
                  "Digital Jahai application required International Phonetic Alphabet (IPA) keyboard to be used with Jahai terms."),
              SizedBox(
                height: 15.0.h,
              ),
              Text(
                  "Please install IPA keyboard using link below and, follow the installation steps: ",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(
                height: 15.0.h,
              ),
              if (GetPlatform.isAndroid) ...[
                Linkify(
                  onOpen: onOpenUrl,
                  options: LinkifyOptions(humanize: true),
                  text:
                      "Android Platform: https://play.google.com/store/apps/details?id=com.google.android.inputmethod.latin",
                ),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black87,
                    ),
                    children: const <TextSpan>[
                      TextSpan(
                          text:
                              "\nStep to add IPA language on Gboard:-\n\n1. Open the "),
                      TextSpan(
                          text: "Settings",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      TextSpan(text: " app.\n2. Go to "),
                      TextSpan(
                          text:
                              "System > Languages & input > Keyboard > Virtual keyboard",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      TextSpan(text: ".\n3. Tap "),
                      TextSpan(
                          text: "Gboard > Languages",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      TextSpan(text: ".\n4. Select "),
                      TextSpan(
                          text: "'International Phonetic Alphabet (IPA)'",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      TextSpan(text: " language."),
                    ],
                  ),
                ),
              ] else if (GetPlatform.isIOS) ...[
                Linkify(
                    onOpen: onOpenUrl,
                    options: LinkifyOptions(humanize: true),
                    text:
                        "IOS Platform: https://apps.apple.com/my/app/ipa-phonetic-keyboard/id1440241497"),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black87,
                    ),
                    children: const <TextSpan>[
                      TextSpan(
                          text:
                              "\nStep to add IPA language on IOS Keyboard:-\n\n1. Open the "),
                      TextSpan(
                          text: "Settings",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      TextSpan(text: " app.\n2. Go to "),
                      TextSpan(
                          text: "General > Keyboard > Keyboards",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      TextSpan(text: ".\n3. Tap on "),
                      TextSpan(
                          text: "'Add New Keyboard'",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      TextSpan(text: ".\n4. Add "),
                      TextSpan(
                          text: "'IPA Keyboard'",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      TextSpan(text: " from the "),
                      TextSpan(
                          text: "'Third-Party Keyboards list'",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      TextSpan(text: ".")
                    ],
                  ),
                ),
              ],
              SizedBox(
                height: 15.0.h,
              ),
              Text(
                  "* Now you can use IPA language while typing by switching to IPA keyboard.")
            ],
          ),
        ),
      ),
    ));
  }
}
