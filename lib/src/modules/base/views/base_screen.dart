  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pizza_app_admin/src/modules/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class BaseScreen extends StatefulWidget {
  const BaseScreen(this.child, {super.key});

  final Widget child;
  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener <SignInBloc, SignInState> (
      listener: (context, state) {
        if (state is SignOutSuccess) {
          html.window.location.reload();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: kToolbarHeight,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                              context.go('/home');
                          },
                          child: Text(
                            "Pizza Admin",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                    
                            ),
                          ),
                        ),
                    
                        SizedBox(width: 20),
                    
                        InkWell(
                          onTap: () {
                              context.go('/create');
                          },
                          child: Text(
                            "Create Pizza",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                    
                        
                      ],
                    ),
      
                    InkWell(
                      onTap: () {
                        context.read<SignInBloc>().add(SignOutRequired());
                      },
                      child: Row(
                        children: [
                          Text(
                            "Logout",
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.logout
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      
            Expanded(
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}