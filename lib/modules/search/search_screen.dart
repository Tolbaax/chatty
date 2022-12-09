import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../shared/widgets/text_form_filed.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  late Map<String, dynamic> userMap;
  bool isShowUser = false;
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75.h,
        leadingWidth: 30.w,
        leading: Center(
          child: Padding(
            padding: EdgeInsetsDirectional.only(start: 10.sp),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
          ),
        ),
        title: DefaultTextFormFiled(
          controller: searchController,
          prefixIcon: const Icon(Icons.search),
          hintText: 'Search for a user',
          onChanged: (val) {
            setState(() {
              isShowUser = true;
            });
          },
          onFiledSubmitted: (String value) async {
            searchController.clear();
          },
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("users")
            .where('name', isGreaterThanOrEqualTo: searchController.text)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blueGrey,
              ),
            );
          }
          return isShowUser
              ? ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {},
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            '${(snapshot.data! as dynamic).docs[index]['image']}'),
                      ),
                      title: Text(
                          '${(snapshot.data! as dynamic).docs[index]['name']}'),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    height: 10.h,
                  ),
                  itemCount: (snapshot.data! as dynamic).docs.length,
                )
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.sp),
                  child: Column(
                    children: [
                      Expanded(
                        child: Lottie.network(
                            'https://assets6.lottiefiles.com/packages/lf20_l5qvxwtf.json'),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
