// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

// Project imports:
import '../utils/debounce.dart';
import '../utils/http_service.dart';

class LibraryController extends GetxController {
  var isLoading = false.obs;
  var isSuccess = false.obs;

  late TextEditingController jahaiTermController;
  late TextEditingController malayTermController;
  late TextEditingController englishTermController;
  late TextEditingController descriptionController;
  late TextEditingController termCategoryController;

  late Future storeTermFuture;

  @override
  void onInit() {
    super.onInit();

    jahaiTermController = TextEditingController();
    malayTermController = TextEditingController();
    englishTermController = TextEditingController();
    descriptionController = TextEditingController();
    termCategoryController = TextEditingController();
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

  void initStoreTermFuture() {
    storeTermFuture = storeTerm();
  }

  Future storeTerm() async {
    isLoading.value = true;
    isSuccess.value = false;

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

      isSuccess.value = true;
    }

    isLoading.value = false;

    return;
  }

  void onSubmitSuccess() {
    Debouncer(milliseconds: 2000).run(() {
      Get.back();
    });
  }

  Widget statusModal() {
    once(
        isLoading,
        (value) => {
              if (isLoading.isFalse) {onSubmitSuccess()}
            });
    return Material(
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: FutureBuilder<dynamic>(
            future: storeTermFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (isLoading.isTrue ||
                  snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.none) {
                return Center(
                  child: Column(
                    children: [
                      SizedBox(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 40, bottom: 20, left: 100, right: 100),
                          child: Lottie.asset('assets/lottie/loading.json',
                              repeat: false),
                        ),
                      ),
                      Text('Loading ...',
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
                            padding: EdgeInsets.only(
                                top: 40, bottom: 20, left: 100, right: 100),
                            child: Lottie.asset(
                                'assets/lottie/loading-failed.json',
                                repeat: false),
                          ),
                        ),
                        Text('Opps.. Something went wrong!',
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
                            padding: EdgeInsets.only(
                                top: 40, bottom: 20, left: 100, right: 100),
                            child: Lottie.asset(
                                (isSuccess.isTrue
                                    ? 'assets/lottie/loading-success.json'
                                    : 'assets/lottie/loading-failed.json'),
                                repeat: false),
                          ),
                        ),
                        Text(
                            (isSuccess.isTrue
                                ? 'New term was added.'
                                : 'Opps.. Something went wrong!'),
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
          ),
        ),
      ),
    );
  }
}