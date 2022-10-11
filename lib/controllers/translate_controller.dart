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
import '../models/terms.dart';
import '../utils/debounce.dart';
import '../utils/http_service.dart';

class TranslateController extends GetxController {
  List<String> language = ["jahai", "malay", "english"];

  var originLang = "".obs;
  var transLang = "".obs;

  var isTyping = false.obs;

  late TextEditingController searchController;

  final debouncer = Debouncer(milliseconds: 1500);

  Terms? terms;

  late Future getTranslationFuture;

  @override
  void onInit() {
    super.onInit();

    originLang.value = language.elementAt(0);
    transLang.value = language.elementAt(1);
    searchController = TextEditingController();
    terms = Terms();
    initGetTranslationFuture();
  }

  @override
  void onClose() {
    searchController.dispose();

    super.onClose();
  }

  String capitalize(s) => s[0].toUpperCase() + s.substring(1);

  void switchLang() {
    var temp = originLang.value;
    originLang.value = transLang.value;
    transLang.value = temp;

    initGetTranslationFuture();
  }

  void initGetTranslationFuture() {
    getTranslationFuture = getTranslation();
  }

  Future getTranslation() async {
    var search = searchController.text;

    terms!.terms = List.empty();

    if (search == "") {
      return terms;
    } else {
      try {
        var payload = {'language': originLang.value, 'search': search};

        final headers = {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        };

        await HttpService()
            .post('/library/translate', headers, payload)
            .then((response) {
          if (response.statusCode == 200) {
            terms = Terms.parseTerms(response.body);
          }
        });
        return terms;
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
        return terms;
      }
    }
  }

  Widget translationListBuilder() {
    return FutureBuilder<dynamic>(
      future: getTranslationFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData && snapshot.data.terms.length > 0) {
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
                termCard(snapshot.data),
                SizedBox(
                  height: 100.0.h,
                ),
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
                        ? "Sorry! No translation found.."
                        : ''),
                  ],
                ),
              ),
            );
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      },
    );
  }

  Widget termCard(data) {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 25.0.w),
        itemCount: data.terms != null ? data.terms.length : 0,
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
                    offset: Offset(5, 10),
                    blurRadius: 20.0,
                    color: const Color(0xff181d5f).withOpacity(0.5),
                  )
                ],
                borderRadius: BorderRadius.all(Radius.circular(25))),
            padding: EdgeInsets.fromLTRB(20.0.w, 10.0.h, 20.0.w, 40.0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  originLang.value == language.elementAt(0)
                      ? (data.terms[index].jahai_term ?? '')
                      : (data.terms[index].malay_term ?? ''), //Search term
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
                                    ? "- ${data.terms[index].malay_term}"
                                    : "- ${data.terms[index].jahai_term}",
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
                //               "- ${ data.terms[index].english_term }",
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
                              (data.terms[index].description ?? ''),
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
                              "- ${data.terms[index].term_category}",
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
              offset: Offset(5, 10),
              blurRadius: 20.0,
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
}
