// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

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

  void openDrawer() {
    xOffsetMain.value = 240;
    yOffsetMain.value = 140;
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
      await launchUrl(url);
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
                  Text("How to Use?",
                      style: TextStyle(
                          color: Colors.grey[600],
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
                height: 25.0.h,
              ),
              Text(
                  "Digital Jahai application required International Phonetic Alphabet (IPA) Keyboard to be used with Jahai terms."),
              SizedBox(
                height: 20.0.h,
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
                Text(
                    "\nStep to add IPA language on Gboard:-\n\n1. Open the Settings app.\n2. System > Languages & input > Keyboard > Virtual keyboard\n3. Tap Gboard and then Languages\n4. Pick International Phonetic Alphabet (IPA) language."),
                SizedBox(
                  height: 15.0.h,
                )
              ] else if (GetPlatform.isIOS) ...[
                Linkify(
                    onOpen: onOpenUrl,
                    options: LinkifyOptions(humanize: true),
                    text:
                        "IOS Platform: https://apps.apple.com/my/app/ipa-phonetic-keyboard/id1440241497"),
                Text(
                    "\nStep to add IPA language on IOS Keyboard:-\n\n1. Open the Settings app\n2. Go to General > Keyboard > Keyboards\n3. Tap on 'Add New Keyboard'.\n4. Add 'IPA Keyboard' from the 'Third-Party Keyboards list'."),
                SizedBox(
                  height: 15.0.h,
                )
              ],
              Text(
                  "* Now you can use IPA language while typing by switching keyboard language to IPA.")
            ],
          ),
        ),
      ),
    ));
  }
}
