import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:digital_jahai/utils/http_service.dart';
import 'package:iconly/iconly.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final TextEditingController jahaiTermController = TextEditingController();
  final TextEditingController malayTermController = TextEditingController();
  final TextEditingController englishTermController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController termCategoryController = TextEditingController();

  Future _storeLibrary(BuildContext context) async {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.loading,
        text: "Please wait...",
        barrierDismissible: false);

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

    final response = await HttpService().post('/library/store', headers, payload);

    if (response.statusCode == 200) {
      if (!mounted) return;
      Navigator.pop(context);

      jahaiTermController.text = "";
      malayTermController.text = "";
      englishTermController.text = "";
      descriptionController.text = "";
      termCategoryController.text = "";

      CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          title: "Thank you!!!",
          text: "New terms successfully added.");
    } else {
      if (!mounted) return;
      Navigator.pop(context);

      CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          title: 'Oops...',
          text: 'Sorry, something went wrong');
    }
  }

  @override
  void initState() {
    super.initState();
  }

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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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
                            Navigator.pop(context);
                          },
                          color: Colors.white,
                          icon: Icon(
                            IconlyLight.arrow_left_2,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 20.0.w),
                      child: Text(
                        "Jahai Language\nRepository",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: const Color(0xff181d5f),
                            // color: const Color(0xfffafafa),
                            fontSize: 36.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15.0.h,
                ),
                Container(
                    // margin: EdgeInsets.symmetric(horizontal: 15.0.w),
                    padding: EdgeInsets.symmetric(
                        vertical: 25.0.h, horizontal: 20.0.w),
                    // height: MediaQuery.of(context).size.height,
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(20),
                    //   color: const Color(0xfffafafa),
                    //   boxShadow: [
                    //     BoxShadow(
                    //       color: Colors.white.withOpacity(0.4),
                    //       spreadRadius: 1,
                    //       blurRadius: 20,
                    //       offset: const Offset(
                    //           0, 4), // changes position of shadow
                    //     ),
                    //   ],
                    // ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Add New Term to Repository",
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600)),
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
                            decoration: InputDecoration(
                                labelText: 'Jahai Term',
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                  // backgroundColor: Colors.white,
                                ),
                                // errorText: 'Error message',
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide:
                                        BorderSide(color: Colors.white)),
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
                                    borderSide:
                                        BorderSide(color: Colors.white)),
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
                        // Container(
                        //   decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     borderRadius: BorderRadius.circular(10),
                        //     boxShadow: [
                        //       BoxShadow(
                        //         offset: Offset(0, 2),
                        //         blurRadius: 3.0,
                        //         color: Color(0xFF8B8DA3).withOpacity(0.3),
                        //       )
                        //     ],
                        //   ),
                        //   child: TextFormField(
                        //     controller: englishTermController,
                        //     decoration: InputDecoration(
                        //         labelText: 'English Term',
                        //         labelStyle: TextStyle(
                        //           color: Colors.grey,
                        //           backgroundColor: Colors.white,
                        //         ),
                        //         // errorText: 'Error message',
                        //         enabledBorder: OutlineInputBorder(
                        //             borderRadius: BorderRadius.all(
                        //                 Radius.circular(10.0)),
                        //             borderSide:
                        //                 BorderSide(color: Colors.white)),
                        //         focusedBorder: OutlineInputBorder(
                        //             borderRadius: BorderRadius.all(
                        //                 Radius.circular(10.0)),
                        //             borderSide:
                        //                 BorderSide(color: Colors.grey))
                        //         // suffixIcon: Icon(
                        //         //   Icons.error,
                        //         // ),
                        //         ),
                        //   ),
                        // ),
                        // SizedBox(height: 30.0),
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
                                    borderSide:
                                        BorderSide(color: Colors.white)),
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
                                    borderSide:
                                        BorderSide(color: Colors.white)),
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
                        SizedBox(height: 30.0),
                        Divider(
                          height: 50.0,
                          thickness: 0.3,
                          indent: 5,
                          endIndent: 5,
                          color: Colors.grey,
                        ),
                        Container(
                          width: double.infinity,
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
                                  color:
                                      const Color(0xffec6882).withOpacity(0.4),
                                )
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: TextButton(
                            onPressed: () {
                              _storeLibrary(context);
                            },
                            child: Text("Sumbit",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                        ),
                      ],
                    )),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: <Widget>[
                //     Container(
                //       margin: EdgeInsets.symmetric(
                //           horizontal: 20.0.w, vertical: 20.0.h),
                //       padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                //       decoration: BoxDecoration(
                //           gradient: LinearGradient(
                //             begin: Alignment.topLeft,
                //             end: Alignment.bottomRight,
                //             colors: const [
                //               Color(0xffeb7c91),
                //               Color(0xffec6882),
                //             ],
                //           ),
                //           boxShadow: [
                //             BoxShadow(
                //               offset: Offset(5, 10),
                //               blurRadius: 20.0,
                //               color: const Color(0xffec6882).withOpacity(0.4),
                //             )
                //           ],
                //           borderRadius:
                //               BorderRadius.all(Radius.circular(10.0))),
                //       child: TextButton(
                //         onPressed: () {
                //           _storeLibrary(context);
                //         },
                //         child: Text("Sumbit",
                //             style: TextStyle(
                //               color: Colors.white,
                //               fontWeight: FontWeight.w600,
                //             )),
                //       ),
                //     ),
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
