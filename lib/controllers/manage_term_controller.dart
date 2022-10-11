// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// Project imports:
import '../models/index.dart';
import '../utils/http_service.dart';

class ManageTermController extends GetxController {
  var isTyping = false.obs;
  var isLoading = false.obs;

  late ScrollController scrollController;
  var scrollTop = false.obs;
  var currentPage = 1;
  var prevPage = 0;
  var lastPage = 1;

  late TextEditingController searchController;

  List<Term> terms = [];

  // late Future getTermListFuture;

  final _formKey = GlobalKey<FormState>();

  late TextEditingController jahaiTermController;
  late TextEditingController malayTermController;
  late TextEditingController englishTermController;
  late TextEditingController descriptionController;
  late TextEditingController termCategoryController;

  @override
  void onInit() {
    super.onInit();

    scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.offset > 10.0 && scrollTop.isFalse) {
        update();
        scrollTop.value = true;
      }

      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (currentPage <= lastPage) {
          getTermList();
        }
      }
    });

    searchController = TextEditingController();
    jahaiTermController = TextEditingController();
    malayTermController = TextEditingController();
    englishTermController = TextEditingController();
    descriptionController = TextEditingController();
    termCategoryController = TextEditingController();

    getTermList();
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    jahaiTermController.dispose();
    malayTermController.dispose();
    englishTermController.dispose();
    descriptionController.dispose();
    termCategoryController.dispose();

    super.onClose();
  }

  // void initGetTermListFuture() {
  //   getTermListFuture = getTermList();
  // }

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

  Widget termListBuilder() {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        itemCount: terms.isEmpty ? 0 : terms.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
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
                  showCupertinoModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      isDismissible: true,
                      builder: (context) => detailModal(terms[index]));
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
                            onPressed: () {},
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
                                // showCupertinoModalBottomSheet(
                                //     context: context,
                                //     backgroundColor: Colors.white,
                                //     builder: (context) {
                                //       return statusModal();
                                //     });
                                // update();
                                // initStoreTermFuture();
                                // update();
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
}
