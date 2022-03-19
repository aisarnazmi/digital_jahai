import 'package:flutter/material.dart';

import 'package:digital_jahai_malay/screens/library.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TranslateScreen extends StatefulWidget {
  const TranslateScreen({Key? key}) : super(key: key);

  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  String firstLang = 'Jahai';
  String secondLang = 'Malay';
  final TextEditingController _searchTerm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
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
                            borderRadius: BorderRadius.all(Radius.circular(50.0))),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 12.0.w),
                      child: Text(
                        "Jahai Language\nRepository",
                        style: TextStyle(
                            color: const Color(0xff181d5f),
                            fontSize: 34.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 20.0.h),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0.w,
                      vertical: 5.0.h // 5 top and bottom
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // color: Colors.grey[100],
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(5, 10),
                          blurRadius: 40.0,
                          color: Color.fromARGB(255, 139, 141, 163).withOpacity(0.4),
                        )
                      ],
                    ),
                    child: TextField(
                      controller: _searchTerm,
                      decoration: const InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        icon: Icon(
                          Icons.search,
                          color: Colors.black38,
                          size: 24,
                        ),
                        hintText: 'Type term to translate...',
                        hintStyle: TextStyle(color: Colors.black38),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                  child: Container(
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
                          'gadiŋ', //Search term
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
                                  Text('Malay Term',
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
                                      '- gading',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white),
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
                                  Text('English Term',
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
                                      '- tusk',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white),
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
                                      "Of boar and elephant; from Malay gading 'tusk', 'ivory'.Of boar and elephant; from Malay gading 'tusk', 'ivory''ivory'.Of boar and elephant; from Malay gading 'tusk''ivory'.Of boar and elephant; from Malay gading 'tusk''ivory'.Of boar and elephant; from Malay gading 'tusk''ivory'.Of boar and elephant; from Malay gading 'tusk''ivory'.Of boar and elephant; from Malay gading 'tusk'",
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
                                      '- Animal Part',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white),
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
                )
              ],
            ),
          ),
        ),
      ),
      bottomSheet: 
        Container(
          margin: EdgeInsets.only(bottom: 20.0.h),
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
                offset: const Offset(0, 3), // changes position of shadow
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
                  firstLang,
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
                          colors: [
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
                          var temp = firstLang;
                          firstLang = secondLang;
                          secondLang = temp;
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
                  secondLang,
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp),
                )),
              ),
              const Spacer()
            ],
          ),
        )
      ,
    );
  }
}
