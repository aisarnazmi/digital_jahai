import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff181d5f),
            Color(0xff112043),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // backgroundColor: const Color(0xfffafafa),
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
                                colors: [
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
                                  BorderRadius.all(Radius.circular(50.0))),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: Colors.white,
                            icon: Icon(
                              Icons.arrow_back,
                              size: 22.w,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 12.0.w),
                        child: Text(
                          "Jahai Language\nRepository",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              // color: const Color(0xff181d5f),
                              color: const Color(0xfffafafa),
                              fontSize: 34.sp,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 35.0.h,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: const Color(0xfffafafa),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.5),
                              spreadRadius: 6,
                              blurRadius: 20,
                              offset: const Offset(
                                  0, 4), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding:
                              EdgeInsets.fromLTRB(20.0.w, 25.0.h, 20.0.w, 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(5, 5),
                                      blurRadius: 40.0,
                                      color: Color(0xFF8B8DA3).withOpacity(0.3),
                                    )
                                  ],
                                ),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      labelText: 'Jahai Term',
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                        backgroundColor: Colors.white,
                                      ),
                                      // errorText: 'Error message',
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide:
                                              BorderSide(color: Colors.white)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide:
                                              BorderSide(color: Colors.grey))
                                      // suffixIcon: Icon(
                                      //   Icons.error,
                                      // ),
                                      ),
                                ),
                              ),
                              SizedBox(height: 30.0.h),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(5, 5),
                                      blurRadius: 40.0,
                                      color: Color(0xFF8B8DA3).withOpacity(0.3),
                                    )
                                  ],
                                ),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      labelText: 'Malay Term',
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                        backgroundColor: Colors.white,
                                      ),
                                      // errorText: 'Error message',
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide:
                                              BorderSide(color: Colors.white)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide:
                                              BorderSide(color: Colors.grey))
                                      // suffixIcon: Icon(
                                      //   Icons.error,
                                      // ),
                                      ),
                                ),
                              ),
                              SizedBox(height: 30.0.h),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(5, 5),
                                      blurRadius: 40.0,
                                      color: Color(0xFF8B8DA3).withOpacity(0.3),
                                    )
                                  ],
                                ),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      labelText: 'English Term',
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                        backgroundColor: Colors.white,
                                      ),
                                      // errorText: 'Error message',
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide:
                                              BorderSide(color: Colors.white)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide:
                                              BorderSide(color: Colors.grey))
                                      // suffixIcon: Icon(
                                      //   Icons.error,
                                      // ),
                                      ),
                                ),
                              ),
                              SizedBox(height: 30.0.h),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(5, 5),
                                      blurRadius: 40.0,
                                      color: Color(0xFF8B8DA3).withOpacity(0.3),
                                    )
                                  ],
                                ),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      labelText: 'Category',
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                        backgroundColor: Colors.white,
                                      ),
                                      // errorText: 'Error message',
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide:
                                              BorderSide(color: Colors.white)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide:
                                              BorderSide(color: Colors.grey))
                                      // suffixIcon: Icon(
                                      //   Icons.error,
                                      // ),
                                      ),
                                ),
                              ),
                              SizedBox(height: 30.0.h),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(5, 5),
                                      blurRadius: 40.0,
                                      color: Color(0xFF8B8DA3).withOpacity(0.3),
                                    )
                                  ],
                                ),
                                child: TextFormField(
                                  minLines: 4,
                                  maxLines: 8,
                                  decoration: InputDecoration(
                                      labelText: 'Description',
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                        backgroundColor: Colors.white,
                                      ),
                                      // errorText: 'Error message',
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide:
                                              BorderSide(color: Colors.white)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide:
                                              BorderSide(color: Colors.grey))
                                      // suffixIcon: Icon(
                                      //   Icons.error,
                                      // ),
                                      ),
                                ),
                              ),
                              SizedBox(height: 30.0.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20.0.w),
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
                                            color: const Color(0xffec6882)
                                                .withOpacity(0.4),
                                          )
                                        ],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text("Sumbit",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1
                                      )),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
