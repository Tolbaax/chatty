import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../network/models/user_model.dart';
import '../../../shared/resources/global.dart';
import '../../../shared/widgets/buttons.dart';
import '../../../shared/widgets/text_form_filed.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel userModel;
  const EditProfileScreen({Key? key, required this.userModel})
      : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    final cubit = SettingsCubit.get(context);
    cubit.nameController.text = widget.userModel.name.toString();
    cubit.phoneController.text = widget.userModel.phone.toString();
    cubit.bioController.text = widget.userModel.bio.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = SettingsCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
            titleSpacing: 0.0,
            title: const Text(
              'Edit Profile',
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    cubit.updateUserData();
                  },
                  child: const Text(
                    'UPDATE',
                    style: TextStyle(fontSize: 17),
                  )),
              SizedBox(
                width: 10.w,
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                if (state is UpdateUserDataLoading)
                  const LinearProgressIndicator(
                    color: Colors.blueGrey,
                    backgroundColor: Colors.white,
                  ),
                SizedBox(
                  height: 185.h,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    clipBehavior: Clip.none,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topCenter,
                        child: Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Container(
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
                            BuildCameraIcon(onPressed: () {
                              cubit.getCoverImage();
                            }),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: -5,
                        child: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 55.0.sp,
                              child: CircleAvatar(
                                radius: 53.sp,
                                backgroundColor: Colors.grey.shade100,
                                backgroundImage: cubit.profileImage == null
                                    ? NetworkImage('${widget.userModel.image}')
                                    : FileImage(cubit.profileImage!)
                                        as ImageProvider,
                              ),
                            ),
                            Positioned(
                              right: -7,
                              bottom: -5,
                              child: BuildCameraIcon(onPressed: () {
                                cubit.getProfileImage();
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: cubit.formKey,
                    child: Column(
                      children: [
                        DefaultTextFormFiled(
                          controller: cubit.nameController,
                          label: 'Name',
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return 'name must not be empty';
                            } else if (value.toString().length < 3) {
                              return 'name must contain at least 3 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        DefaultTextFormFiled(
                          controller: cubit.bioController,
                          label: 'Bio',
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return 'bio must not be empty';
                            } else if (value.toString().length < 3) {
                              return 'bio must contain at least 3 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        DefaultTextFormFiled(
                          controller: cubit.phoneController,
                          label: 'Phone',
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return 'phone must not be empty';
                            } else if (value.toString().length < 11) {
                              return 'bio must contain at least 11 digits';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
