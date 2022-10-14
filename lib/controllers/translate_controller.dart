// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:skeleton_text/skeleton_text.dart';

// Project imports:
import '../models/index.dart';
import '../utils/debouncer.dart';
import '../utils/http_service.dart';

class TranslateController extends GetxController {
  List<String> language = ["jahai", "malay", "english"];
  List<Term> terms = [];

  var originLang = "".obs;
  var transLang = "".obs;
  var isTyping = false.obs;
  var scrollTop = false.obs;
  var currentPage = 1;
  var prevPage = 0;
  var lastPage = 1;

  final serchDebouncer = Debouncer(milliseconds: 1500);

  late TextEditingController searchController;
  late ScrollController scrollController;
  late Future getTranslationFuture;

  @override
  void onInit() {
    super.onInit();

    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset > 300.0 && scrollTop.isFalse) {
        update();
        scrollTop.value = true;
      }

      if (scrollController.offset < 150.0 && scrollTop.isTrue) {
        update();
        scrollTop.value = false;
      }

      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (currentPage <= lastPage) {
          initGetTranslationFuture();
        }
      }
    });

    originLang.value = language.elementAt(0);
    transLang.value = language.elementAt(1);
    searchController = TextEditingController();

    initGetTranslationFuture();
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();

    super.onClose();
  }

  String capitalize(s) => s[0].toUpperCase() + s.substring(1);

  void switchLang() {
    var temp = originLang.value;
    originLang.value = transLang.value;
    transLang.value = temp;
    update();

    resetList();
    initGetTranslationFuture();
  }

  void toTop() {
    scrollController.animateTo(0,
        duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
  }

  void resetList() {
    currentPage = 1;
    prevPage = 0;
    lastPage = 1;
    terms = [];
  }

  void initGetTranslationFuture() {
    getTranslationFuture = getTranslation();
  }

  Future<void> getTranslation() async {
    print('Current: $currentPage, Prev: $prevPage, Last: $lastPage');

    var language = originLang.value;
    var search = searchController.text;

    if (search == "") {
      return;
    }

    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      };

      await HttpService()
          .get(
              '/library/translate?page=$currentPage&language=$language&search=$search',
              headers)
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
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }

    update();
  }

  Widget translationListBuilder() {
    return FutureBuilder<dynamic>(
      future: getTranslationFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (terms.isEmpty &&
            snapshot.connectionState == ConnectionState.waiting) {
          if (searchController.text == "") {
            return Center(
              child: Padding(
                padding: EdgeInsets.only(top: 70.0.h),
                child: UnDraw(
                  height: 200.0.h,
                  color: Color.fromRGBO(52, 48, 144, 1),
                  illustration: UnDrawIllustration.bibliophile,
                  errorWidget: Column(
                    children: [
                      Icon(Icons.perm_scan_wifi_outlined),
                      SizedBox(height: 10.0.w),
                      Text("No internet connection"),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Translation(s): ",
                          style: TextStyle(
                              fontSize: 17.sp, fontWeight: FontWeight.w700),
                        )
                      ],
                    )),
                SizedBox(
                  height: 15.0.h,
                ),
                skeletonCard()
              ],
            );
          }
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (terms.isNotEmpty) {
            return Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Translation(s): ",
                          style: TextStyle(
                              fontSize: 17.sp, fontWeight: FontWeight.w700),
                        )
                      ],
                    )),
                SizedBox(
                  height: 15.0.h,
                ),
                termCard(terms),
                if (currentPage < lastPage) ...[
                  skeletonCard()
                ] else ...[
                  SizedBox(
                    height: 50.0.h,
                  ),
                ],
              ],
            );
          } else {
            return Padding(
              padding: EdgeInsets.only(top: 70.0.h),
              child: Center(
                child: Column(
                  children: [
                    UnDraw(
                        height: 200.0.h,
                        color: Color(0xff343090),
                        illustration:
                            (isTyping.isFalse && searchController.text != "")
                                ? UnDrawIllustration.void_
                                : UnDrawIllustration.bibliophile,
                        errorWidget: Column(
                          children: [
                            Icon(Icons.perm_scan_wifi_outlined),
                            SizedBox(height: 10.0.w),
                            Text("No internet connection"),
                          ],
                        )),
                    SizedBox(height: 10.0.h),
                    Text((isTyping.isFalse && searchController.text != "")
                        ? "Sorry! No translation found."
                        : ''),
                  ],
                ),
              ),
            );
          }
        }
      },
    );
  }

  Widget termCard(List<Term> terms) {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 25.0.w),
        itemCount: terms.isNotEmpty ? terms.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.only(bottom: 20.0.h),
            decoration: BoxDecoration(
                // color: Color(0xff5969e3),
                // color: Color(0xff112043),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff181d5f),
                    Color(0xff112043),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 5),
                    color: const Color(0xff181d5f).withOpacity(0.5),
                  )
                ],
                borderRadius: BorderRadius.all(Radius.circular(25))),
            padding: EdgeInsets.fromLTRB(20.0.w, 20.0.h, 20.0.w, 40.0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  originLang.value == language.elementAt(0)
                      ? (terms[index].jahai_term ?? '')
                      : (terms[index].malay_term ?? ''), //Search term
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 32.sp,
                      color: Colors.white),
                ),
                SizedBox(height: 15.h),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 13.h, horizontal: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                              originLang.value == language.elementAt(0)
                                  ? 'Malay Term'
                                  : 'Jahai Term',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                  color: Colors.white)),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(left: 10.0.w),
                              child: Text(
                                originLang.value == language.elementAt(0)
                                    ? "- ${terms[index].malay_term}"
                                    : "- ${terms[index].jahai_term}",
                                style: TextStyle(
                                    fontSize: 16.sp, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0.h),
                // Padding(
                //   padding: EdgeInsets.symmetric(
                //       vertical: 13.h, horizontal: 10.w),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Row(
                //         children: [
                //           Text('English Term',
                //               style: TextStyle(
                //                   fontWeight: FontWeight.w600,
                //                   fontSize: 16.sp,
                //                   color: Colors.white)),
                //         ],
                //       ),
                //       SizedBox(height: 10.h),
                //       Row(
                //         children: [
                //           Padding(
                //             padding: EdgeInsets.only(left: 10.0.w),
                //             child: Text(
                //               "- ${ terms[index].english_term }",
                //               style: TextStyle(
                //                   fontSize: 16.sp,
                //                   color: Colors.white),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(height: 10.0.h),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 13.h, horizontal: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Description',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                  color: Colors.white)),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              (terms[index].description ?? ''),
                              overflow: TextOverflow.visible,
                              softWrap: true,
                              style: TextStyle(
                                  height: 1.5,
                                  fontSize: 16.sp,
                                  color: Colors.white),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0.h),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 13.h, horizontal: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Category',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                  color: Colors.white)),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10.0.w),
                            child: Text(
                              "- ${terms[index].term_category}",
                              style: TextStyle(
                                  fontSize: 16.sp, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget skeletonCard() {
    return Container(
      margin: EdgeInsets.fromLTRB(25.w, 0, 25.w, 20.h),
      decoration: BoxDecoration(
          // color: Color(0xff5969e3),
          // color: Color(0xff112043),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff181d5f),
              Color(0xff112043),
            ],
          ),
          boxShadow: [
            BoxShadow(
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 5),
              color: const Color(0xff181d5f).withOpacity(0.5),
            )
          ],
          borderRadius: BorderRadius.all(Radius.circular(25))),
      padding: EdgeInsets.fromLTRB(20.0.w, 30.0.h, 20.0.w, 40.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SkeletonAnimation(
            shimmerColor: Colors.white10.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            shimmerDuration: 800,
            child: Container(
              height: 33.0.h,
              width: 120.0.w,
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(6),
                //  boxShadow: shadowList,
              ),
            ),
          ),
          SizedBox(height: 15.0.h),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SkeletonAnimation(
                      shimmerColor: Colors.white10.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                      shimmerDuration: 800,
                      child: Container(
                        height: 20.0.h,
                        width: 90.0.w,
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(5),
                          //  boxShadow: shadowList,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10.0.w),
                      child: SkeletonAnimation(
                        shimmerColor: Colors.white10.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                        shimmerDuration: 800,
                        child: Container(
                          height: 20.0.h,
                          width: 110.0.w,
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(5),
                            //  boxShadow: shadowList,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0.h),
          // Padding(
          //   padding:
          //       EdgeInsets.symmetric(vertical: 13.h, horizontal: 10.w),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Row(
          //         children: [
          //           SkeletonAnimation(
          //             shimmerColor: Colors.white10.withOpacity(0.1),
          //             borderRadius: BorderRadius.circular(5),
          //             shimmerDuration: 800,
          //             child: Container(
          //               height: 20.0.h,
          //               width: 90.0.w,
          //               decoration: BoxDecoration(
          //                 color: Colors.white12,
          //                 borderRadius: BorderRadius.circular(5),
          //                 //  boxShadow: shadowList,
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //       SizedBox(height: 10.h),
          //       Row(
          //         children: [
          //           Padding(
          //             padding: EdgeInsets.only(left: 10.0.w),
          //             child: SkeletonAnimation(
          //               shimmerColor: Colors.white10.withOpacity(0.1),
          //               borderRadius: BorderRadius.circular(5),
          //               shimmerDuration: 800,
          //               child: Container(
          //                 height: 20.0.h,
          //                 width: 110.0.w,
          //                 decoration: BoxDecoration(
          //                   color: Colors.white12,
          //                   borderRadius: BorderRadius.circular(5),
          //                   //  boxShadow: shadowList,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(height: 10.0.h),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SkeletonAnimation(
                      shimmerColor: Colors.white10.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                      shimmerDuration: 800,
                      child: Container(
                        height: 20.0.h,
                        width: 90.0.w,
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(5),
                          //  boxShadow: shadowList,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonAnimation(
                      shimmerColor: Colors.white10.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                      shimmerDuration: 800,
                      child: Container(
                        height: 20.0.h,
                        width: 270.0.w,
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(5),
                          //  boxShadow: shadowList,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.0.h,
                    ),
                    SkeletonAnimation(
                      shimmerColor: Colors.white10.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                      shimmerDuration: 800,
                      child: Container(
                        height: 20.0.h,
                        width: 200.0.w,
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(5),
                          //  boxShadow: shadowList,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.0.h,
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0.h),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SkeletonAnimation(
                      shimmerColor: Colors.white10.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                      shimmerDuration: 800,
                      child: Container(
                        height: 20.0.h,
                        width: 80.0.w,
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(5),
                          //  boxShadow: shadowList,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10.0.w),
                      child: SkeletonAnimation(
                        shimmerColor: Colors.white10.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                        shimmerDuration: 800,
                        child: Container(
                          height: 20.0.h,
                          width: 110.0.w,
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(5),
                            //  boxShadow: shadowList,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget languageSwitcher() {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: const BorderRadius.only(
        //   topLeft: Radius.circular(15),
        //   topRight: Radius.circular(15),
        // ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            spreadRadius: 7,
            blurRadius: 5,
            offset: const Offset(7, 0), // changes position of shadow
          ),
        ],
      ),
      height: 80.0.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Spacer(),
          Expanded(
            child: Center(
                child: Text(
              capitalize(originLang.value),
              style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp),
            )),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: const [
                        Color(0xffeb7c91),
                        Color(0xffec6882),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(5, 10),
                        blurRadius: 20.0,
                        color: const Color(0xffec6882).withOpacity(0.4),
                      )
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                child: IconButton(
                  onPressed: () {
                    toTop();
                    switchLang();
                  },
                  color: Colors.white,
                  icon: Icon(
                    Icons.swap_horiz,
                    size: 24.w,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
                child: Text(
              capitalize(transLang.value),
              style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp),
            )),
          ),
          const Spacer()
        ],
      ),
    );
  }
}
