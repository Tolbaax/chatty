import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/modules/chats/cubit/cubit.dart';
import 'package:social_app/modules/post/cubit/cubit.dart';
import 'package:social_app/modules/settings/cubit/cubit.dart';
import 'package:social_app/modules/splash/splash_screen.dart';
import 'package:social_app/network/services/notification_service.dart';
import 'package:social_app/shared/lcoal/cache_helper.dart';
import 'package:social_app/shared/resources/bloc_observer.dart';
import 'package:social_app/shared/resources/global.dart';
import 'package:social_app/shared/styles/themes.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  // make sure that everything in methode is finished, then open the app
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotificationService.initialize();
  await Firebase.initializeApp();
  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();
  timeago.setLocaleMessages('en', timeago.EnShortMessages());
  uId = CacheHelper.getData(key: 'uId');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LayoutCubit()..getUserData()),
        BlocProvider(create: (context) => AddPostCubit()..getUserData()),
        BlocProvider(create: (context) => ChatsCubit()..getUsers()),
        BlocProvider(create: (context) => SettingsCubit()..getUserData()),
      ],
      child: ScreenUtilInit(
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Chatty',
          theme: light,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
