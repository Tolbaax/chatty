import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/modules/register/cubit/cubit.dart';
import 'package:social_app/modules/register/cubit/states.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/widgets/buttons.dart';
import 'package:social_app/shared/widgets/logo.dart';
import 'package:social_app/shared/widgets/navigation.dart';
import 'package:social_app/shared/widgets/show_toast.dart';
import 'package:social_app/shared/widgets/text_form_filed.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            showToast(
                text: 'Registered Successfully', state: ToastState.success);
            navigateAndFinish(context, const LoginScreen());
          }
        },
        builder: (context, state) {
          final cubit = RegisterCubit.get(context);
          return Scaffold(
            body: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: AppColors.darkBlue,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 60.h,
                      ),
                      const LogoContainer(),
                    ],
                  ),
                ),
                Positioned(
                  top: 180.0,
                  bottom: 0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(70.r),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.sp),
                      child: SingleChildScrollView(
                        child: Form(
                          key: cubit.formKey,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20.h,
                              ),
                              Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 45.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.darkBlue,
                                ),
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                              DefaultTextFormFiled(
                                controller: cubit.name,
                                inputType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                hintText: 'Enter your name',
                                label: 'Name',
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Name is required';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 25.h,
                              ),
                              DefaultTextFormFiled(
                                controller: cubit.email,
                                inputType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                hintText: 'Enter your Email',
                                label: 'Email',
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'E-mail is required';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 25.h,
                              ),
                              DefaultTextFormFiled(
                                controller: cubit.password,
                                inputType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.next,
                                label: 'Password',
                                hintText: 'Enter your Password',
                                secure: cubit.isPassword,
                                suffix: cubit.suffix,
                                suffixTab: () {
                                  cubit.changeVisibility();
                                },
                                validator: (value) =>
                                    value!.length < 5 || value.isEmpty
                                        ? 'Enter valid Password'
                                        : null,
                              ),
                              SizedBox(
                                height: 25.h,
                              ),
                              DefaultTextFormFiled(
                                controller: cubit.phone,
                                label: 'Phone',
                                hintText: 'Enter your Phone',
                                inputType: TextInputType.phone,
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'E-mail is required';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                              state is! RegisterLoadingState
                                  ? DefaultButton(
                                      onTap: () {
                                        cubit.userRegister();
                                      },
                                      title: 'Register',
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.tealBlue,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
