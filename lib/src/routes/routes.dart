import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pizza_app_admin/src/blocs/authenticationBloc/authentication_bloc.dart';
import 'package:pizza_app_admin/src/modules/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:pizza_app_admin/src/modules/auth/views/login_screen.dart';
import 'package:pizza_app_admin/src/modules/base/views/base_screen.dart';
import 'package:pizza_app_admin/src/modules/create_pizza/blocs/create_pizza_bloc/create_pizza_bloc.dart';
import 'package:pizza_app_admin/src/modules/create_pizza/blocs/upload_photo_bloc/upload_photo_bloc.dart';
import 'package:pizza_app_admin/src/modules/create_pizza/views/create_pizza_screen.dart';
import 'package:pizza_app_admin/src/modules/home/views/home_screen.dart';
import 'package:pizza_app_admin/src/modules/splash/views/splash_screen.dart';
import 'package:pizza_repository/pizza_repository.dart';

final _navKey = GlobalKey<NavigatorState>();
final _shellNavigationKey = GlobalKey<NavigatorState>();

GoRouter router (AuthenticationBloc authBloc) {
  return GoRouter(
    navigatorKey: _navKey,
    initialLocation: '/',
    // ignore: body_might_complete_normally_nullable
    redirect: (context, state) {
      if (authBloc.state.status == AuthenticationStatus.unknown) {
        return '/';
      }
    },
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigationKey,
        builder: (context, state, child) {
          if (state.fullPath == '/login' || state.fullPath == '/') {
            return child;
          }
          
          return BlocProvider <SignInBloc> (
            create: (context) => SignInBloc(context.read<AuthenticationBloc>().userRepository),
            child: BaseScreen(child),
          );
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) {
              return BlocProvider <AuthenticationBloc>.value(
                value: BlocProvider.of<AuthenticationBloc>(context),
                child: SplashScreen(),
              );
            }
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) {
              return BlocProvider <AuthenticationBloc>.value(
                value: BlocProvider.of<AuthenticationBloc>(context),
                child: BlocProvider<SignInBloc>(
                  create: (context) => SignInBloc(
                    context.read<AuthenticationBloc>().userRepository
                  ),
                  child: const SignInScreen(),
                ),
              );
            }
          ),
          GoRoute(
            path: '/home',
            builder: (context, state) {
              return HomeScreen();
            }
          ),
          GoRoute(
            path: '/create',
            builder: (context, state) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<UploadPhotoBloc>(
                    create: (context) => UploadPhotoBloc(
                      FirebasePizzaRepo(),
                    ),
                  ),
                  BlocProvider<CreatePizzaBloc>(
                    create: (context) => CreatePizzaBloc(
                      FirebasePizzaRepo(),
                    ),
                  ),
                ],
              child: const CreatePizzaScreen(),
              );
            }
          ),
        ],
      ),
    ],
  );
}