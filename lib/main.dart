import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tec_bloc/firebase_options.dart';
import 'package:tec_bloc/locals/db/db_helper.dart';
import 'package:tec_bloc/observer.dart';
import 'package:tec_bloc/service_locator.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDependencies();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  final DbHelper dbHelper = DbHelper();
  await dbHelper.database;
  Bloc.observer = const SimpleBlocObserver();
  runApp(
    const MyApp()
  );
}
