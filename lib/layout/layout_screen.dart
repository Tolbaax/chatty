import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/modules/notifications/notifications_screen.dart';
import 'package:social_app/modules/post/add_post_screen.dart';
import 'package:social_app/network/services/notification_service.dart';
import 'package:social_app/shared/widgets/buttons.dart';
import 'package:social_app/shared/widgets/navigation.dart';
import 'package:social_app/shared/widgets/show_toast.dart';
import 'package:social_app/shared/widgets/sign_out.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({Key? key}) : super(key: key);

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  @override
  void initState() {
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((message) {
      LocalNotificationService.display(message);
    });
    LocalNotificationService.storeToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutStates>(
      listener: (context, state) {
        if (state is SignOutSuccessState) {
          navigateAndFinish(context, const LoginScreen());
          showToast(text: 'Sign out Successfully', state: ToastState.success);
        }
      },
      builder: (context, state) {
        final cubit = LayoutCubit.get(context);
        return Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(
              cubit.titles[cubit.currentIndex],
              style: TextStyle(
                color: Colors.blueGrey.shade700,
                letterSpacing: cubit.currentIndex == 0 ? 2 : 0,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  navigateTo(context, const NotificationScreen());
                },
                icon: const Icon(Icons.notifications_active_outlined),
                splashRadius: 20.0.sp,
              ),
              if (cubit.currentIndex == 3) const SignOut(),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  child: const AddPostScreen(),
                  type: PageTransitionType.fade,
                ),
              );
            },
            backgroundColor: Colors.blueGrey.shade600,
            child: const Icon(CupertinoIcons.add, size: 28),
          ),
          body: SafeArea(
            bottom: false,
            child: cubit.screens[cubit.currentIndex],
          ),
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 7.w,
            child: SizedBox(
              height: 42.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BottomTabBar(
                      index: 0,
                      icon: CupertinoIcons.home,
                      onPressed: (index) {
                        cubit.changeBottomNav(index);
                      }),
                  BottomTabBar(
                      index: 1,
                      icon: CupertinoIcons.search,
                      onPressed: (index) {
                        cubit.changeBottomNav(index);
                      }),
                  Padding(
                    padding: EdgeInsets.only(left: 65.w),
                    child: BottomTabBar(
                        index: 2,
                        icon: CupertinoIcons.chat_bubble_text_fill,
                        onPressed: (index) {
                          cubit.changeBottomNav(index);
                        }),
                  ),
                  BottomTabBar(
                      index: 3,
                      icon: CupertinoIcons.settings,
                      onPressed: (index) {
                        cubit.changeBottomNav(index);
                      }),
                ]
                    .map(
                      (e) => e,
                    )
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
