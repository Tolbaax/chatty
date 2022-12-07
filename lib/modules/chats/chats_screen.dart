import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/modules/chats/cubit/cubit.dart';
import 'package:social_app/modules/chats/cubit/states.dart';

import '../../shared/widgets/chat_item.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatsCubit, ChatStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = ChatsCubit.get(context);
        return Scaffold(
          body: BuildCondition(
            condition:
                cubit.users.isNotEmpty && state is! GetAllUsersLoadingState,
            builder: (context) => ListView.separated(
              itemCount: cubit.users.length,
              itemBuilder: (context, index) =>
                  BuildChatItem(userModel: cubit.users[index]),
              separatorBuilder: (context, index) => SizedBox(
                height: 15.h,
              ),
            ),
            fallback: (context) => const Center(
              child: CircularProgressIndicator(
                color: Colors.blueGrey,
              ),
            ),
          ),
        );
      },
    );
  }
}
