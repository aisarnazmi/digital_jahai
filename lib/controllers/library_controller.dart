import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../utils/http_service.dart';

class LibraryController extends GetxController {
  var isLoading = false.obs;
  var isSuccess = false.obs;

  late TextEditingController jahaiTermController;
  late TextEditingController malayTermController;
  late TextEditingController englishTermController;
  late TextEditingController descriptionController;
  late TextEditingController termCategoryController;

  @override
  void onInit() {
    jahaiTermController = TextEditingController();
    malayTermController = TextEditingController();
    englishTermController = TextEditingController();
    descriptionController = TextEditingController();
    termCategoryController = TextEditingController();

    super.onInit();
  }

  @override
  void onClose() {
    jahaiTermController.dispose();
    malayTermController.dispose();
    englishTermController.dispose();
    descriptionController.dispose();
    termCategoryController.dispose();

    super.onClose();
  }

  Future storeTerm() async {
    var payload = {
      "jahai_term": jahaiTermController.text,
      "malay_term": malayTermController.text,
      "english_term": englishTermController.text,
      "description": descriptionController.text,
      "term_category": termCategoryController.text
    };

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    final response =
        await HttpService().post('/library/store', headers, payload);

    if (response.statusCode == 200) {
      jahaiTermController.text = "";
      malayTermController.text = "";
      englishTermController.text = "";
      descriptionController.text = "";
      termCategoryController.text = "";
    }

    Get.back();
    
    return;
  }

  Widget statusModal() {
    return FutureBuilder<dynamic>(
      future: storeTerm(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              children: [
                SizedBox(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 120.w, vertical: 50.h),
                    child: Lottie.asset('assets/lottie/loading.json',
                        repeat: false),
                  ),
                ),
                Text('Loading...',
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500))
              ],
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                children: [
                  SizedBox(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 120.w, vertical: 50.h),
                      child: Lottie.asset('assets/lottie/loading-failed.json',
                          repeat: false),
                    ),
                  ),
                  Text('Opps. Something when wrong!',
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500))
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                children: [
                  SizedBox(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 120.w, vertical: 50.h),
                      child: Lottie.asset('assets/lottie/loading-success.json',
                          repeat: false),
                    ),
                  ),
                  Text('Term successfully added.',
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500))
                ],
              ),
            );
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      },
    );
  }
}
