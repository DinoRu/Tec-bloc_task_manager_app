import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tec_bloc/core/constants/app_colors.dart';
import 'package:tec_bloc/firebase_options.dart';
import 'package:tec_bloc/observer.dart';
import 'package:tec_bloc/service_locator.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDependencies(); 
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light
    )
  );
  Bloc.observer = const SimpleBlocObserver();
  runApp(const MyApp());
}

