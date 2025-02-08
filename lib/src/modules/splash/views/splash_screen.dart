  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pizza_app_admin/src/blocs/authenticationBloc/authentication_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: BlocBuilder <AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go('/home');
            });
            return Container();
          }
          else if (state.status == AuthenticationStatus.unauthenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go('/login');
            });
            return Container();
          }
          else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}