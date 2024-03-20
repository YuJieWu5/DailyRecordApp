import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController =  TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? _firebaseErrorCode;

  void _onCreatePressed() async{
    if(_formKey.currentState?.validate() ?? false) {
      //TODO: save account info to database
      // GoRouter.of(context).push('/login');
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _userNameController.text,
          password: _passwordController.text,
        );

        User? user = userCredential.user;
        String? uid;
        if (user != null) {
          uid = user.uid;
          Map<String, dynamic> data = {
            'name': _userNameController.text,
            'points': 0,
            // Add other fields as needed
          };
          writeDataWithCustomId("Points", uid!, data);
        } else {
          print("User creation failed");
        }

        setState(() {
          _firebaseErrorCode = "Account successfully create, please sign in.";
        });
      } on FirebaseAuthException catch (ex) {
        print(ex.code);
        print(ex.message);
        setState(() {
          _firebaseErrorCode = ex.code;
        });
      }
    }
  }

  void writeDataWithCustomId(String collectionName, String customDocId, Map<String, dynamic> data) {
    firestore
        .collection(collectionName)
        .doc(customDocId)  // Specify your custom document ID here
        .set(data)
        .then((_) => print('Document successfully written with custom ID $customDocId'))
        .catchError((error) => print('Error writing document: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: GestureDetector(
              child: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onPrimary),
              onTap: (){
                GoRouter.of(context).pop();
              }
          ),
          title: Center(
              child: Text(AppLocalizations.of(context)!.signUp, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary))
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
                                    key: const Key('Email'),
                                    decoration: const InputDecoration(
                                        labelText: 'Username'
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
                          key: const Key('Password'),
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
                      if(_firebaseErrorCode != null) Text(_firebaseErrorCode!),
                      Container(
                          margin: const EdgeInsets.only(top:20.0),
                          child: ElevatedButton(
                            // Note: we are not calling _onSavePressed! We are passing it
                            // like an object to this other widget as a constructor arg.
                              onPressed: _onCreatePressed,
                              child: const Text('Create')
                          )
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        onPressed: ()=> GoRouter.of(context).push('/signIn'),
                        child: Text(AppLocalizations.of(context)!.signIn),
                      )
                    ],
                  ),
                )
            )
        )
    );
  }
}
