import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cpsc5250hw/auth_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController =  TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? invalidUser;

  void _onSignInPressed() async{
    if(_formKey.currentState?.validate() ?? false) {
      //TODO: verify account info

      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _userNameController.text,
          password: _passwordController.text,
        );

        User? user = userCredential.user;
        if (user != null) {
          String uid = user.uid;
          print("User ID: $uid");
          context.read<AuthInfo>().setUserId(uid);
          context.read<AuthInfo>().setUserEmail(_userNameController.text);
        } else {
          print("User not found!");
        }
        GoRouter.of(context).push("/emotion");
      } catch (e) {
        // Handle errors, such as incorrect password, user not found, etc.
        print(e);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: false,
          title: Center(
              child: Text('Sign In', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary))
          ),
        ),
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: SafeArea(
                  child: Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                          child: Center(
                              child: SizedBox(
                                  width: 400.0,
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'Email'
                                    ),
                                    controller: _userNameController,
                                    validator: (newValue) {
                                      if(newValue == null || newValue.isEmpty) {
                                        return 'Email must not be blank.';
                                      }
                                      return null;
                                    },
                                  )
                              )
                          )
                      ),
                      SizedBox(
                        width: 400.0,
                        child: TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Password'
                          ),
                          controller: _passwordController,
                          validator: (newValue) {
                            if(newValue == null || newValue.isEmpty) {
                              return 'Password must not be blank.';
                            }
                            return null;
                          },
                        ),
                      ),
                      invalidUser != null
                          ? Text(invalidUser!, style: const TextStyle(color: Colors.red, fontSize: 12))
                          : Container(),
                      Container(
                          margin: const EdgeInsets.only(top:20.0),
                          child: ElevatedButton(
                            // Note: we are not calling _onSavePressed! We are passing it
                            // like an object to this other widget as a constructor arg.
                              onPressed: _onSignInPressed,
                              child: Text(AppLocalizations.of(context)!.signIn)
                          )
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        onPressed: ()=> GoRouter.of(context).push('/signUp'),
                        child: Text(AppLocalizations.of(context)!.signUp),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        onPressed: ()=> GoRouter.of(context).push('/emotion'),
                        child: Text(AppLocalizations.of(context)!.register),
                      )
                    ],
                  ),
                )
            )
        )
    );
  }
}
