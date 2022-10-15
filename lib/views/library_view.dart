// Flutter imports:
import '../constants/color.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// Project imports:
import '../controllers/library_controller.dart';

class LibraryView extends GetView<LibraryController> {
  const LibraryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LibraryController>(
        init: LibraryController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: colorBackgroundDark,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0.h),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20.0.w),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0))),
                            child: IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              color: colorTextLight,
                              icon: Icon(
                                IconlyLight.arrow_left_2,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: <Widget>[
                      //     Padding(
                      //       padding: EdgeInsets.only(right: 20.0.w),
                      //       child: Text(
                      //         "Jahai Language\nRepository",
                      //         textAlign: TextAlign.right,
                      //         style: TextStyle(
                      //             color: const Color(0xff181d5f),
                      //             // color: const Color(0xfffafafa),
                      //             fontSize: 36.sp,
                      //             fontWeight: FontWeight.w800,
                      //             letterSpacing: -1),
                      //       ),
                      //     )
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: 15.0.h,
                      // ),
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 25.0.h, horizontal: 20.0.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Add New Term to Repository",
                                  style: TextStyle(
                                      color: colorPrimaryLight,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600)),
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
                                          color: colorShadow
                                              .withOpacity(0.5),
                                        )
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller:
                                          controller.jahaiTermController,
                                      decoration: InputDecoration(
                                        labelText: 'Jahai Term',
                                        labelStyle: TextStyle(
                                          color: colorPlaceholderText,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                                color: !!controller.errors
                                                        .contains("jahai")
                                                    ? colorErrorText
                                                    : colorTransparent)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            borderSide:
                                                BorderSide(color: colorBorder)),
                                        suffixIcon: !!controller.errors
                                                .contains("jahai")
                                            ? Icon(Icons.error,
                                                color: colorSecondaryDark)
                                            : null,
                                      ),
                                    ),
                                  ),
                                  if (!!controller.errors
                                      .contains("jahai")) ...[
                                    controller.validationError("Jahai term"),
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
                                          color: colorShadow
                                              .withOpacity(0.5),
                                        )
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller:
                                          controller.malayTermController,
                                      decoration: InputDecoration(
                                        labelText: 'Malay Term',
                                        labelStyle: TextStyle(
                                          color: colorPlaceholderText,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                                color: !!controller.errors
                                                        .contains("malay")
                                                    ? colorErrorText
                                                    : colorTransparent)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            borderSide:
                                                BorderSide(color: colorBorder)),
                                        suffixIcon: !!controller.errors
                                                .contains("malay")
                                            ? Icon(Icons.error,
                                                color: colorSecondaryDark)
                                            : null,
                                      ),
                                    ),
                                  ),
                                  if (!!controller.errors
                                      .contains("malay")) ...[
                                    controller.validationError("Malay term"),
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
                                          color: colorShadow
                                              .withOpacity(0.5),
                                        )
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller:
                                          controller.englishTermController,
                                      decoration: InputDecoration(
                                        labelText: 'English Term',
                                        labelStyle: TextStyle(
                                          color: colorPlaceholderText,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                                color: !!controller.errors
                                                        .contains("english")
                                                    ? colorErrorText
                                                    : colorTransparent)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            borderSide:
                                                BorderSide(color: colorBorder)),
                                        suffixIcon: !!controller.errors
                                                .contains("english")
                                            ? Icon(Icons.error,
                                                color: colorSecondaryDark)
                                            : null,
                                      ),
                                    ),
                                  ),
                                  if (!!controller.errors
                                      .contains("english")) ...[
                                    controller.validationError("English term"),
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
                                          color: colorShadow
                                              .withOpacity(0.5),
                                        )
                                      ],
                                    ),
                                    child: TextFormField(
                                      minLines: 4,
                                      maxLines: 4,
                                      controller:
                                          controller.descriptionController,
                                      decoration: InputDecoration(
                                        labelText: 'Description',
                                        labelStyle: TextStyle(
                                          color: colorPlaceholderText,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                                color: !!controller.errors
                                                        .contains("description")
                                                    ? colorErrorText
                                                    : colorTransparent)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            borderSide:
                                                BorderSide(color: colorBorder)),
                                        suffixIcon: !!controller.errors
                                                .contains("description")
                                            ? Icon(Icons.error,
                                                color: colorSecondaryDark)
                                            : null,
                                      ),
                                    ),
                                  ),
                                  if (!!controller.errors
                                      .contains("description")) ...[
                                    controller.validationError("description"),
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
                                          color: colorShadow
                                              .withOpacity(0.5),
                                        )
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller:
                                          controller.termCategoryController,
                                      decoration: InputDecoration(
                                        labelText: 'Term Category',
                                        labelStyle: TextStyle(
                                          color: colorPlaceholderText,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                                color: !!controller.errors
                                                        .contains("category")
                                                    ? colorErrorText
                                                    : colorTransparent)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            borderSide:
                                                BorderSide(color: colorBorder)),
                                        suffixIcon: !!controller.errors
                                                .contains("category")
                                            ? Icon(Icons.error,
                                                color: colorSecondaryDark)
                                            : null,
                                      ),
                                    ),
                                  ),
                                  if (!!controller.errors
                                      .contains("category")) ...[
                                    controller.validationError("term category")
                                  ],
                                  Divider(
                                    height: 40.0,
                                    thickness: 0.3,
                                    indent: 5,
                                    endIndent: 5,
                                    color: colorPlaceholderText,
                                  ),
                                  Container(
                                    width: double.infinity,
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
                                        if (controller.isLoading.isTrue) {
                                          return;
                                        }

                                        if (controller.validate()) {
                                          showCupertinoModalBottomSheet(
                                              context: context,
                                              backgroundColor: colorBackgroundLight,
                                              isDismissible: false,
                                              builder: (context) {
                                                return controller.statusModal();
                                              });
                                          controller.initStoreTermFuture();
                                        } else {
                                          controller.update();
                                        }
                                      },
                                      child: Text("Sumbit",
                                          style: TextStyle(
                                            color: colorBackgroundLight,
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ),
                                  ),
                                ],
                              ))
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
