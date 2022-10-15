// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// Project imports:
import '../constants/color.dart';
import '../models/index.dart';
import '../utils/debouncer.dart';
import '../utils/http_service.dart';

enum Action { update, delete }

class ManageTermController extends GetxController {
  List<Term> terms = [];
  List<String> errors = [];
  String token = "";

  var isTyping = false.obs;
  var isLoading = false.obs;
  var isSuccess = false.obs;
  var scrollTop = false.obs;
  var currentPage = 1;
  var prevPage = 0;
  var lastPage = 1;

  final serchDebouncer = Debouncer(milliseconds: 1500);
  final openModalDebouncer = Debouncer(milliseconds: 2300);
  final closeModalDebouncer = Debouncer(milliseconds: 2000);

  late ScrollController scrollController;
  late TextEditingController searchController;
  late TextEditingController jahaiTermController;
  late TextEditingController malayTermController;
  late TextEditingController englishTermController;
  late TextEditingController descriptionController;
  late TextEditingController termCategoryController;
  late Future getTermListFuture;
  late Future manageTermFuture;
  late GetStorage box;

  @override
  Future<void> onInit() async {
    super.onInit();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset > 10.0 && scrollTop.isFalse) {
        update();
        scrollTop.value = true;
      }

      if (scrollController.offset < 10.0 && scrollTop.isTrue) {
        update();
        scrollTop.value = false;
      }

      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (currentPage <= lastPage) {
          initGetTermListFuture();
        }
      }
    });

    searchController = TextEditingController();
    jahaiTermController = TextEditingController();
    malayTermController = TextEditingController();
    englishTermController = TextEditingController();
    descriptionController = TextEditingController();
    termCategoryController = TextEditingController();

    initGetTermListFuture();

    await GetStorage.init();
    box = GetStorage();
    if (box.read('token') != null) {
      token = box.read('token');
    }
  }

  @override
  void onClose() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    scrollController.dispose();
    searchController.dispose();
    jahaiTermController.dispose();
    malayTermController.dispose();
    englishTermController.dispose();
    descriptionController.dispose();
    termCategoryController.dispose();

    super.onClose();
  }

  void toTop() {
    scrollController.animateTo(0,
        duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
  }

  void openDetailModal(data) {
    showCupertinoModalBottomSheet(
        context: Get.context as BuildContext,
        backgroundColor: colorBackgroundLight,
        isDismissible: true,
        builder: (context) => detailModal(data));
  }

  void closeModal() {
    closeModalDebouncer.run(() {
      Get.back();
    });
  }

  void resetList() {
    currentPage = 1;
    prevPage = 0;
    lastPage = 1;
    terms = [];
  }

  void initGetTermListFuture() {
    getTermListFuture = getTermList();
  }

  bool validate() {
    errors = [];

    errors.addIf(jahaiTermController.text == "", "jahai");
    errors.addIf(malayTermController.text == "", "malay");
    errors.addIf(englishTermController.text == "", "english");
    errors.addIf(descriptionController.text == "", "description");
    errors.addIf(termCategoryController.text == "", "category");

    if (errors.isNotEmpty) {
      return false;
    }

    return true;
  }

  void initManageTermFuture(action, id) {
    Get.back();

    showCupertinoModalBottomSheet(
        context: Get.context as BuildContext,
        backgroundColor: colorBackgroundLight,
        isDismissible: false,
        builder: (context) {
          return statusModal(action);
        });
    update();

    if (action == Action.update) {
      manageTermFuture = updateTerm(id);
    } else if (action == Action.delete) {
      manageTermFuture = deleteTerm(id);
    }
  }

  Future<void> getTermList() async {
    isLoading.value = true;

    update();

    var search = searchController.text;

    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      };

      await HttpService()
          .get('/library?page=$currentPage&search=$search', headers)
          .then((response) {
        if (response.statusCode == 200) {
          var res = jsonDecode(response.body);

          if (res['current_page'] > prevPage) {
            currentPage++;
            prevPage = res['current_page'];
            lastPage = res['last_page'];

            terms.addAll(Terms.parseTerms(jsonEncode(res['data'])).terms);
          }
        }
      });
      isLoading.value = false;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      isLoading.value = false;
    }

    update();
  }

  Future<void> updateTerm(id) async {
    isLoading.value = true;
    isSuccess.value = false;

    update();

    try {
      var payload = {
        "jahai_term": jahaiTermController.text,
        "malay_term": malayTermController.text,
        "english_term": englishTermController.text,
        "description": descriptionController.text,
        "term_category": termCategoryController.text
      };

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };

      final response =
          await HttpService().put('/library/$id', headers, payload);

      var index = terms.indexWhere((element) => element.id == id);

      if (response.statusCode == 200) {
        var updatedData = jsonDecode(response.body);

        terms[index] = Term.fromJson(updatedData);
        isSuccess.value = true;
      } else {
        openModalDebouncer.run(() {
          openDetailModal(terms[index]);
        });
      }
      isLoading.value = false;

    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      isLoading.value = false;
    }

    update();
  }

  Future<void> deleteTerm(id) async {
    isLoading.value = true;
    isSuccess.value = false;

    update();

    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await HttpService().delete('/library/$id', headers);

      var index = terms.indexWhere((element) => element.id == id);

      if (response.statusCode == 200) {
        terms.removeAt(index);

        isSuccess.value = true;
      } else {
        openModalDebouncer.run(() {
          openDetailModal(terms[index]);
        });
      }
      isLoading.value = false;
      
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      isLoading.value = false;
    }

    update();
  }

  Widget termListBuilder() {
    return FutureBuilder<dynamic>(
      future: getTermListFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (terms.isEmpty) {
          return Center(
            child: Container(
              padding: EdgeInsets.only(top: 30.h, bottom: 30),
              child: searchController.text == ""
                  ? Lottie.asset('assets/lottie/typing-animation.json',
                      height: 36)
                  : isLoading.isFalse
                      ? Text("No record found.",
                          style: TextStyle(color: Colors.grey.shade600))
                      : null,
            ),
          );
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
                primary: false,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                itemCount: terms.isNotEmpty ? terms.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 10.h),
                        title: Container(
                            margin: EdgeInsets.only(bottom: 10.h),
                            child: Text(
                              terms[index].jahai_term ?? "",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w600),
                            )),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Malay: ${terms[index].malay_term ?? '-'}'),
                            SizedBox(height: 10.h),
                            Text('English: ${terms[index].english_term ?? ''}'),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              IconlyLight.arrow_right_2,
                              size: 22,
                            ),
                          ],
                        ),
                        onTap: () {
                          openDetailModal(terms[index]);
                        },
                      ),
                      Row(
                        children: List.generate(
                            1000 ~/ 15,
                            (index) => Expanded(
                                  child: Container(
                                    color: index % 2 == 0
                                        ? colorTransparent
                                        : Colors.black54,
                                    height: 0.3,
                                  ),
                                )),
                      ),
                    ],
                  );
                });
          }
        }
        //else {
        //   return Text('State: ${snapshot.connectionState}');
        // }
      },
    );
  }

  Widget detailModal(data) {
    jahaiTermController.text = data.jahai_term ?? "";
    malayTermController.text = data.malay_term ?? "";
    englishTermController.text = data.english_term ?? "";
    descriptionController.text = data.description ?? "";
    termCategoryController.text = data.term_category ?? "";
    MediaQueryData mediaQueryData = MediaQuery.of(Get.context as BuildContext);
    return GetBuilder<ManageTermController>(
        init: ManageTermController(),
        builder: (context) {
          return Material(
            child: SafeArea(
              child: Padding(
                padding:
                    EdgeInsets.only(bottom: mediaQueryData.viewInsets.bottom),
                child: SingleChildScrollView(
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 25.0.h, horizontal: 20.0.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Manage Term",
                                  style: TextStyle(
                                      color: colorPrimaryLight,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600)),
                              IconButton(
                                  onPressed: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    Get.back();
                                  },
                                  icon: Icon(Icons.close)),
                            ],
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          Form(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: colorBackgroundLight,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 2),
                                        blurRadius: 3.0,
                                        color: colorShadow.withOpacity(0.5),
                                      )
                                    ],
                                  ),
                                  child: TextFormField(
                                    controller: jahaiTermController,
                                    decoration: InputDecoration(
                                      labelText: 'Jahai Term',
                                      labelStyle: TextStyle(
                                        color: colorPlaceholderText,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide: BorderSide(
                                              color: !!errors.contains("jahai")
                                                  ? colorErrorText
                                                  : colorTransparent)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide:
                                              BorderSide(color: colorBorder)),
                                      suffixIcon: !!errors.contains("jahai")
                                          ? Icon(Icons.error,
                                              color: colorSecondaryDark)
                                          : null,
                                    ),
                                  ),
                                ),
                                if (!!errors.contains("jahai")) ...[
                                  validationError("Jahai term"),
                                  SizedBox(height: 10.0),
                                ] else ...[
                                  SizedBox(height: 20.0),
                                ],
                                Container(
                                  decoration: BoxDecoration(
                                    color: colorBackgroundLight,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 2),
                                        blurRadius: 3.0,
                                        color: colorShadow.withOpacity(0.5),
                                      )
                                    ],
                                  ),
                                  child: TextFormField(
                                    controller: malayTermController,
                                    decoration: InputDecoration(
                                      labelText: 'Malay Term',
                                      labelStyle: TextStyle(
                                        color: colorPlaceholderText,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide: BorderSide(
                                              color: !!errors.contains("malay")
                                                  ? colorErrorText
                                                  : colorTransparent)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide:
                                              BorderSide(color: colorBorder)),
                                      suffixIcon: !!errors.contains("malay")
                                          ? Icon(Icons.error,
                                              color: colorSecondaryDark)
                                          : null,
                                    ),
                                  ),
                                ),
                                if (!!errors.contains("malay")) ...[
                                  validationError("Malay term"),
                                  SizedBox(height: 10.0),
                                ] else ...[
                                  SizedBox(height: 20.0),
                                ],
                                Container(
                                  decoration: BoxDecoration(
                                    color: colorBackgroundLight,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 2),
                                        blurRadius: 3.0,
                                        color: colorShadow.withOpacity(0.5),
                                      )
                                    ],
                                  ),
                                  child: TextFormField(
                                    controller: englishTermController,
                                    decoration: InputDecoration(
                                      labelText: 'English Term',
                                      labelStyle: TextStyle(
                                        color: colorPlaceholderText,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide: BorderSide(
                                              color:
                                                  !!errors.contains("english")
                                                      ? colorErrorText
                                                      : colorTransparent)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide:
                                              BorderSide(color: colorBorder)),
                                      suffixIcon: !!errors.contains("english")
                                          ? Icon(Icons.error,
                                              color: colorSecondaryDark)
                                          : null,
                                    ),
                                  ),
                                ),
                                if (!!errors.contains("english")) ...[
                                  validationError("English term"),
                                  SizedBox(height: 10.0),
                                ] else ...[
                                  SizedBox(height: 20.0),
                                ],
                                Container(
                                  decoration: BoxDecoration(
                                    color: colorBackgroundLight,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 2),
                                        blurRadius: 3.0,
                                        color: colorShadow.withOpacity(0.5),
                                      )
                                    ],
                                  ),
                                  child: TextFormField(
                                    minLines: 4,
                                    maxLines: 4,
                                    controller: descriptionController,
                                    decoration: InputDecoration(
                                      labelText: 'Description',
                                      labelStyle: TextStyle(
                                        color: colorPlaceholderText,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide: BorderSide(
                                              color: !!errors
                                                      .contains("description")
                                                  ? colorErrorText
                                                  : colorTransparent)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide:
                                              BorderSide(color: colorBorder)),
                                      suffixIcon:
                                          !!errors.contains("description")
                                              ? Icon(Icons.error,
                                                  color: colorSecondaryDark)
                                              : null,
                                    ),
                                  ),
                                ),
                                if (!!errors.contains("description")) ...[
                                  validationError("description"),
                                  SizedBox(height: 10.0),
                                ] else ...[
                                  SizedBox(height: 20.0),
                                ],
                                Container(
                                  decoration: BoxDecoration(
                                    color: colorBackgroundLight,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 2),
                                        blurRadius: 3.0,
                                        color: colorShadow.withOpacity(0.5),
                                      )
                                    ],
                                  ),
                                  child: TextFormField(
                                    controller: termCategoryController,
                                    decoration: InputDecoration(
                                      labelText: 'Term Category',
                                      labelStyle: TextStyle(
                                        color: colorPlaceholderText,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide: BorderSide(
                                              color:
                                                  !!errors.contains("category")
                                                      ? colorErrorText
                                                      : colorTransparent)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide:
                                              BorderSide(color: colorBorder)),
                                      suffixIcon: !!errors.contains("category")
                                          ? Icon(Icons.error,
                                              color: colorSecondaryDark)
                                          : null,
                                    ),
                                  ),
                                ),
                                if (!!errors.contains("category")) ...[
                                  validationError("term category")
                                ],
                                Divider(
                                  height: 40.0,
                                  thickness: 0.3,
                                  indent: 5,
                                  endIndent: 5,
                                  color: colorPlaceholderText,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: colorSecondaryDark,
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(3, 3),
                                              blurRadius: 10.0,
                                              color: colorSecondaryDark
                                                  .withOpacity(0.5),
                                            )
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      child: IconButton(
                                        onPressed: () {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();

                                          if (isLoading.isTrue) {
                                            return;
                                          }

                                          initManageTermFuture(
                                              Action.delete, data.id);
                                        },
                                        icon: Icon(IconlyBold.delete,
                                            color: colorTextLight),
                                      ),
                                    ),
                                    SizedBox(width: 15.w),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: colorSecondaryDark,
                                            boxShadow: [
                                              BoxShadow(
                                                offset: Offset(3, 3),
                                                blurRadius: 10.0,
                                                color: colorSecondaryDark
                                                    .withOpacity(0.5),
                                              )
                                            ],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        child: TextButton(
                                          onPressed: () {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();

                                            if (isLoading.isTrue) {
                                              return;
                                            }

                                            if (validate()) {
                                              initManageTermFuture(
                                                  Action.update, data.id);
                                            } else {
                                              update();
                                            }
                                          },
                                          child: Text("Save",
                                              style: TextStyle(
                                                color: colorTextLight,
                                                fontWeight: FontWeight.w600,
                                              )),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ])),
                        ],
                      )),
                ),
              ),
            ),
          );
        });
  }

  Widget validationError(field) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
        child: Text(
          'Please input $field.',
          style: TextStyle(color: colorErrorText, fontSize: 12.sp),
        ));
  }

  Widget statusModal(action) {
    once(
        isLoading,
        (value) => {
              if (isLoading.isFalse) {closeModal()}
            });
    return Material(
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: FutureBuilder<dynamic>(
            future: manageTermFuture,
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
                              repeat: true),
                        ),
                      ),
                      Text('Loading ...',
                          style: TextStyle(
                              color: colorTextDark,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500)),
                      SizedBox(height: 10)
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
                                color: colorTextDark,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500)),
                        SizedBox(height: 10)
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
                                ? (action == Action.update
                                    ? 'Term has been updated.'
                                    : 'Term has been deleted.')
                                : 'Opps.. Something went wrong!'),
                            style: TextStyle(
                                color: colorTextDark,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500)),
                        SizedBox(height: 10)
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
