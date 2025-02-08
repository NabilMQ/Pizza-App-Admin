import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pizza_app_admin/app.dart';
import 'package:pizza_app_admin/firebase_options.dart';
import 'package:pizza_app_admin/simple_bloc_observer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  setPathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: dotenv.env["supabaseUrl"]!,
    anonKey: dotenv.env["supabaseKey"]!,
  );

  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}