import 'dart:async';
import 'dart:convert';

import 'package:digital_jahai/controllers/screen_controller.dart';
import 'package:digital_jahai/models/term.dart';
import 'package:digital_jahai/utils/call_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:digital_jahai/screens/library_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/debounce.dart';

enum Language { jahai, malay, english }

class TranslateScreen extends StatefulWidget {
  const TranslateScreen({Key? key}) : super(key: key);

  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  final screenC = Get.put(ScreenController());

  static Language _originLang = Language.values[0];
  Language _transLang = Language.values[1];
  final TextEditingController _searchController = TextEditingController();

  List<Term> termList = [];

  Future _getTranslation(String search) async {
    if (search == "") {
      return [];
    } else {
      try {
        var payload = {'language': _originLang.name, 'search': search};

        final headers = {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        };
        final response =
            await CallApi().post('/library/translate', headers, payload);
        if (response.statusCode == 200) {
          return json.decode(response.body);
        }
      } catch (e) {
        // print(e.toString());
      }
    }
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  final debouncer = Debouncer(milliseconds: 1500);

  // Timer? _debounce;

  // void _onSearchChanged(String search) {
  //   if (_debounce?.isActive ?? false) _debounce?.cancel();
  //   _debounce = Timer(Duration(milliseconds: 1500), () {
  //     // do something with searchText
  //     if (search != '') {
  //       _getTranslation(search);
  //     }
  //   });
  // }

  // @override
  // void dispose() {
  //   _debounce?.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                      child: IconButton(
                          onPressed: () => screenC.openDrawer(),
                          icon: SvgPicture.asset('assets/images/menu.svg',
                              semanticsLabel: 'Menu')),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const LibraryScreen()));
                          },
                          color: Colors.white,
                          icon: Icon(
                            Icons.menu_book,
                            size: 22.w,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20.0.w),
                      child: Text(
                        "Jahai Language\nRepository",
                        style: TextStyle(
                            color: const Color(0xff181d5f),
                            fontSize: 36.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20.0.w, vertical: 20.0.h),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.0.w, vertical: 5.0.h // 5 top and bottom
                        ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // color: Colors.grey[100],
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 2),
                          blurRadius: 3.0,
                          color: Color(0xFF8B8DA3).withOpacity(0.3),
                        )
                      ],
                    ),
                    child: TextFormField(
                      controller: _searchController,
                      onTap: () => screenC.closeDrawer(),
                      onChanged: (value) {
                        // setState(() {
                        // _searchController.text = val;
                        // _onSearchChanged(_searchController.text);
                        // });
                        setState(() {
                          debouncer.run(() {
                            if (value != '') {
                              _getTranslation(value);
                              print(value);
                            }
                          });
                        });
                      },
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        icon: Icon(
                          IconlyBroken.search,
                          color: Colors.black54,
                          size: 22,
                        ),
                        hintText: "Enter ${_originLang.name} term...",
                        hintStyle: TextStyle(color: Colors.black54),
                        suffixIcon: _searchController.text == ""
                            ? null
                            : IconButton(
                                color: Colors.black54,
                                iconSize: 24,
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                  });
                                }),
                      ),
                    ),
                  ),
                ),
                FutureBuilder<dynamic>(
                  future: _getTranslation(_searchController.text),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        if (_searchController.text == "") {
                          return Padding(
                            padding: EdgeInsets.only(top: 70.0.h),
                            child: Column(
                              children: [
                                UnDraw(
                                  height: 200.0.h,
                                  color: Color(0xff343090),
                                  illustration: UnDrawIllustration.bibliophile,
                                  errorWidget: Column(
                                    children: [
                                      Icon(Icons.perm_scan_wifi_outlined),
                                      SizedBox(height: 10.0.w),
                                      Text("No internet connection"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Column(
                            children: <Widget>[
                              Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0.w),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Translation(s): ",
                                        style: TextStyle(
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  )),
                              SizedBox(
                                height: 15.0.h,
                              ),
                              SkeletonCard()
                            ],
                          );
                        }
                      default:
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.data == null ||
                            snapshot.data.length <= 0) {
                          return Padding(
                            padding: EdgeInsets.only(top: 70.0.h),
                            child: Column(
                              children: [
                                UnDraw(
                                    height: 200.0.h,
                                    color: Color(0xff343090),
                                    illustration: _searchController.text != ""
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
                                Text(_searchController.text != ""
                                    ? "Sorry! No translation found.."
                                    : ''),
                              ],
                            ),
                          );
                        } else {
                          return Column(
                            children: <Widget>[
                              Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0.w),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Translation(s): ",
                                        style: TextStyle(
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  )),
                              SizedBox(
                                height: 15.0.h,
                              ),
                              TermCard(snapshot.data),
                              SizedBox(
                                height: 100.0.h,
                              ),
                            ],
                          );
                        }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
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
                capitalize(_originLang.name),
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
                      setState(() {
                        var temp = _originLang;
                        _originLang = _transLang;
                        _transLang = temp;
                      });
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
                capitalize(_transLang.name),
                style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp),
              )),
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
      child: Container(
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
            SizedBox(height: 25.0.h),
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 13.0.h, horizontal: 10.0.w),
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
            //       EdgeInsets.symmetric(vertical: 13.0.h, horizontal: 10.0.w),
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
              padding:
                  EdgeInsets.symmetric(vertical: 13.0.h, horizontal: 10.0.w),
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
              padding:
                  EdgeInsets.symmetric(vertical: 13.0.h, horizontal: 10.0.w),
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
      ),
    );
  }
}

class TermCard extends StatelessWidget {
  final List? list;

  const TermCard(this.list, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: list == null ? 0 : list?.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0.w),
            child: Container(
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
              padding: EdgeInsets.fromLTRB(20.0.w, 30.0.h, 20.0.w, 40.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _TranslateScreenState._originLang == Language.jahai
                        ? list![i]['jahai_term']
                        : list![i]['malay_term'], //Search term
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 30.sp,
                        color: Colors.white),
                  ),
                  SizedBox(height: 25.0.h),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 13.0.h, horizontal: 10.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                                _TranslateScreenState._originLang ==
                                        Language.jahai
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
                            Padding(
                              padding: EdgeInsets.only(left: 10.0.w),
                              child: Text(
                                _TranslateScreenState._originLang ==
                                        Language.jahai
                                    ? "- ${list![i]['malay_term']}"
                                    : "- ${list![i]['jahai_term']}",
                                style: TextStyle(
                                    // fontStyle: FontStyle.italic,
                                    color: Colors.white),
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
                  //       vertical: 13.0.h, horizontal: 10.0.w),
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
                  //               "- ${list![i]['english_term']}",
                  //               style: TextStyle(
                  //                   // fontStyle: FontStyle.italic,
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
                    padding: EdgeInsets.symmetric(
                        vertical: 13.0.h, horizontal: 10.0.w),
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
                                list![i]['description'],
                                overflow: TextOverflow.visible,
                                softWrap: true,
                                style: TextStyle(
                                    height: 1.5,
                                    fontStyle: FontStyle.italic,
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
                    padding: EdgeInsets.symmetric(
                        vertical: 13.0.h, horizontal: 10.0.w),
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
                                "- ${list![i]['term_category']}",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
