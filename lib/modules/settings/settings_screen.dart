import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_app/modules/settings/cubit/cubit.dart';
import 'package:social_app/modules/settings/cubit/states.dart';
import 'package:social_app/modules/settings/widgets/edit_profile_screen.dart';
import 'package:social_app/shared/resources/global.dart';
import 'package:social_app/shared/widgets/navigation.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return BuildCondition(
          condition: currentUser != null || state is GetUserDataLoadingState,
          builder: (context) => SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 185.h,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    clipBehavior: Clip.none,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topCenter,
                        child: Container(
                          height: 150.h,
                          width: double.infinity,
                          foregroundDecoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage('${currentUser!.header}'),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -5,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 55.0.sp,
                          child: CircleAvatar(
                            radius: 53.sp,
                            backgroundImage:
                                NetworkImage('${currentUser!.image}'),
                            backgroundColor: Colors.grey.shade100,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 13.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.sp),
                  child: Text(
                    '${currentUser!.name}',
                    style:
                        TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  '${currentUser!.bio}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60.0.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: Column(
                          children: [
                            Text(
                              '13',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16.sp),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              'Posts',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        child: Column(
                          children: [
                            Text(
                              '514',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16.sp),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              'Followers',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        child: Column(
                          children: [
                            Text(
                              '113',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16.sp),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              'Following',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            navigateTo(
                              context,
                              MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                      create: (context) => SettingsCubit()),
                                ],
                                child:
                                    EditProfileScreen(userModel: currentUser!),
                              ),
                            );
                          },
                          child: const Text('Edit Profile'),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (context) => SettingsCubit(),
                                  )
                                ],
                                child:
                                    EditProfileScreen(userModel: currentUser!),
                              ),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.edit_outlined,
                          size: 18.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(
              color: Colors.blueGrey,
            ),
          ),
        );
      },
    );
  }
}
