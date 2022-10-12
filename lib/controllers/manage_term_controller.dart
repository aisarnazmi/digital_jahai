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
import '../models/index.dart';
import '../utils/debounce.dart';
import '../utils/http_service.dart';

enum Action { update, delete }

class ManageTermController extends GetxController {
  var isTyping = false.obs;
  var isLoading = false.obs;
  var isSuccess = false.obs;

  late ScrollController scrollController;
  var scrollTop = false.obs;
  var currentPage = 1;
  var prevPage = 0;
  var lastPage = 1;

  List<Term> terms = [];

  late TextEditingController searchController;
  late TextEditingController jahaiTermController;
  late TextEditingController malayTermController;
  late TextEditingController englishTermController;
  late TextEditingController descriptionController;
  late TextEditingController termCategoryController;

  final _formKey = GlobalKey<FormState>();

  late Future getTermListFuture;
  late Future manageTermFuture;

  late GetStorage box;
  String token = "";

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

  void openDetailModal(data) {
    showCupertinoModalBottomSheet(
        context: Get.context as BuildContext,
        backgroundColor: Colors.white,
        isDismissible: true,
        builder: (context) => detailModal(data));
  }

  void closeModal() {
    Debouncer(milliseconds: 2000).run(() {
      Get.back();
    });
  }

  void initGetTermListFuture() {
    getTermListFuture = getTermList();
  }

  void initManageTermFuture(action, id) {
    Get.back();

    showCupertinoModalBottomSheet(
        context: Get.context as BuildContext,
        backgroundColor: Colors.white,
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
        Debouncer(milliseconds: 2300).run(() {
          openDetailModal(terms[index]);
        });
      }
      isLoading.value = false;
      update();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      isLoading.value = false;
    }
  }

  Future<void> deleteTerm(id) async {
    isLoading.value = true;
    isSuccess.value = false;

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
        Debouncer(milliseconds: 2300).run(() {
          openDetailModal(terms[index]);
        });
      }
      isLoading.value = false;
      update();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      isLoading.value = false;
    }
  }

  Widget termListBuilder() {
    return FutureBuilder<dynamic>(
      future: getTermListFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (terms.isEmpty) {
          return Center(
            child: Container(
              padding: EdgeInsets.only(top: 30.h, bottom: 30),
              child: Lottie.asset('assets/lottie/typing-animation.json',
                  height: 36),
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
                itemCount: terms.isEmpty ? 0 : terms.length,
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
                                  fontSize: 18.sp,
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w600),
                            )),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Malay: ${terms[index].malay_term ?? '-'}'),
                            SizedBox(height: 10.h),
                            Text(
                                'English: ${terms[index].english_term ?? ''}'),
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
                                        ? Colors.transparent
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

    return Material(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              padding:
                  EdgeInsets.symmetric(vertical: 25.0.h, horizontal: 20.0.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Manage Term",
                            style: TextStyle(
                                color: const Color(0xff181d5f),
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600)),
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(Icons.close)),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 2),
                            blurRadius: 3.0,
                            color: Color(0xFF8B8DA3).withOpacity(0.3),
                          )
                        ],
                      ),
                      child: TextFormField(
                        controller: jahaiTermController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {}
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Jahai Term',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                              // backgroundColor: Colors.white,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.grey))),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 2),
                            blurRadius: 3.0,
                            color: Color(0xFF8B8DA3).withOpacity(0.3),
                          )
                        ],
                      ),
                      child: TextFormField(
                        controller: malayTermController,
                        decoration: InputDecoration(
                            labelText: 'Malay Term',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                              // backgroundColor: Colors.white,
                            ),
                            // errorText: 'Error message',
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.grey))
                            // suffixIcon: Icon(
                            //   Icons.error,
                            // ),
                            ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 2),
                            blurRadius: 3.0,
                            color: Color(0xFF8B8DA3).withOpacity(0.3),
                          )
                        ],
                      ),
                      child: TextFormField(
                        controller: englishTermController,
                        decoration: InputDecoration(
                            labelText: 'English Term',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                              // backgroundColor: Colors.white,
                            ),
                            // errorText: 'Error message',
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.grey))
                            // suffixIcon: Icon(
                            //   Icons.error,
                            // ),
                            ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 2),
                            blurRadius: 3.0,
                            color: Color(0xFF8B8DA3).withOpacity(0.3),
                          )
                        ],
                      ),
                      child: TextFormField(
                        controller: descriptionController,
                        minLines: 4,
                        maxLines: 4,
                        decoration: InputDecoration(
                            labelText: 'Description',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                              // backgroundColor: Colors.white,
                            ),
                            // errorText: 'Error message',
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.grey))
                            // suffixIcon: Icon(
                            //   Icons.error,
                            // ),
                            ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 2),
                            blurRadius: 3.0,
                            color: Color(0xFF8B8DA3).withOpacity(0.3),
                          )
                        ],
                      ),
                      child: TextFormField(
                        controller: termCategoryController,
                        decoration: InputDecoration(
                            labelText: 'Term Category',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                              // backgroundColor: Colors.white,
                            ),
                            // errorText: 'Error message',
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.grey))
                            // suffixIcon: Icon(
                            //   Icons.error,
                            // ),
                            ),
                      ),
                    ),
                    Divider(
                      height: 40.0,
                      thickness: 0.3,
                      indent: 5,
                      endIndent: 5,
                      color: Colors.grey,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                end: Alignment.topLeft,
                                colors: const [
                                  Color(0xffeb7c91),
                                  Color(0xffec6882),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(5, 10),
                                  blurRadius: 20.0,
                                  color:
                                      const Color(0xffec6882).withOpacity(0.4),
                                )
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: IconButton(
                            onPressed: () {
                              initManageTermFuture(Action.delete, data.id);
                              update();
                            },
                            icon: Icon(IconlyBold.delete, color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: const [
                                    Color(0xffeb7c91),
                                    Color(0xffec6882),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(5, 10),
                                    blurRadius: 20.0,
                                    color: const Color(0xffec6882)
                                        .withOpacity(0.4),
                                  )
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            child: TextButton(
                              onPressed: () {
                                // if (_formKey.currentState!.validate()) {
                                //   storeLibrary(context);
                                // }
                                initManageTermFuture(Action.update, data.id);
                                update();
                              },
                              child: Text("Save",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
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
                                ? (action == Action.update
                                    ? 'Term has been updated.'
                                    : 'Term has been deleted.')
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
