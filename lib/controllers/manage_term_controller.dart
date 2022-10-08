// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

// Project imports:
import '../models/index.dart';
import '../models/terms.dart';
import '../utils/debounce.dart';
import '../utils/http_service.dart';

class ManageTermController extends GetxController {
  var isTyping = false.obs;

  late TextEditingController searchController;

  final debouncer = Debouncer(milliseconds: 1500);

  Terms? terms;

  late Future getTermListFuture;

  @override
  void onInit() {
    super.onInit();

    searchController = TextEditingController();
    terms = Terms();
    initGetTermListFuture();
  }

  @override
  void onClose() {
    searchController.dispose();

    super.onClose();
  }

  void initGetTermListFuture() {
    getTermListFuture = getTermList();
  }

  Future getTermList() async {
    var search = searchController.text;

    terms!.terms = List.empty();

    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      };
      final response =
          await HttpService().get('/library?search=$search', headers);

      if (response.statusCode == 200) {
        terms = Terms.parseTerms(response.body);
      }
      return terms;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return terms;
    }
  }

  Widget termListBuilder() {
    return FutureBuilder<dynamic>(
      future: getTermListFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: const <Widget>[
              //   skeletonList()
              CircularProgressIndicator()
            ],
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return termList(snapshot.data);
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      },
    );
  }

  Widget termList(data) {
    return SlidableAutoCloseBehavior(
      closeWhenTapped: true,
      child: ListView.builder(
          primary: false,
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          itemCount: data.terms != null ? data.terms.length : 0,
          itemBuilder: (BuildContext context, int index) {
            return Slidable(
                groupTag: "terms",
                key: ValueKey(index),
                endActionPane: ActionPane(
                  extentRatio: 0.25,
                  motion: BehindMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                      },
                      backgroundColor: Color(0xffec6882),
                      foregroundColor: Colors.white,
                      icon: IconlyBold.delete,
                      label: 'Delete',
                      autoClose: false,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                      title: Container(
                          margin: EdgeInsets.only(bottom: 10.h),
                          child: Text(
                            data.terms[index].jahai_term ?? "",
                            style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w600),
                          )),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Malay: ${data.terms[index].malay_term ?? '-'}'),
                          SizedBox(height: 10.h),
                          Text(
                              'English: ${data.terms[index].english_term ?? ''}'),
                        ],
                      ),
                      trailing: Column(
                        children: const [
                          Expanded(
                            child: Icon(
                              IconlyLight.arrow_right_2,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
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
                ));
          }),
    );
  }
}
