import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:omar_chat_app/widgets/image_pick.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var logIn = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
  final _form = GlobalKey<FormState>();
  File? pickedImageHere;
  var isAuthenticating = false;
  var enteredUserName = '';

  void submit() async {
    var isValid = _form.currentState!.validate();
    if (!isValid || !logIn && pickedImageHere == null) {
      return;
    }
    _form.currentState!.save();
    try {
      if (logIn) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        setState(() {
          isAuthenticating = true;
        });
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        final imagesRef = FirebaseStorage.instance
            .ref()
            .child('user_places')
            .child('${userCredentials.user!.uid}.jpg');
        await imagesRef.putFile(pickedImageHere!);
        final url =await imagesRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.email)
            .set({
          'email': _enteredEmail,
          'url': url,
          'user name': enteredUserName,
          
        });
        print(url);
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'auth failed'),
        ),
      
      );
        setState(() {
        isAuthenticating = false;
      });
    }

    print(_enteredEmail);
    print(_enteredPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 20, top: 30),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _form,
                    child: Column(
                      children: [
                        if (!logIn)
                          ImagePick(
                            onPickImage: (pickedImage) =>
                                pickedImageHere = pickedImage,
                          ),
                        TextFormField(
                          decoration: const InputDecoration(
                              label: Text('enter your email')),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'please insert a valid value';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredEmail = value!;
                          },
                        ),
                        if (!logIn)
                          TextFormField(
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  value.trim().length < 4) {
                                return 'please enter at least 4 characters';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              enteredUserName = value!;
                            },
                          ),
                        TextFormField(
                          decoration: const InputDecoration(
                              label: Text('enter your password')),
                          obscureText: true,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                value.trim().length < 6) {
                              return 'please insert a valid value';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredPassword = value!;
                          },
                        ),
                        if (isAuthenticating) CircularProgressIndicator(),
                        if (!isAuthenticating)
                          ElevatedButton(
                              onPressed: submit,
                              child: Text(logIn ? 'Log In' : 'Sign Up')),
                        if (!isAuthenticating)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                logIn = !logIn;
                              });
                            },
                            child: Text(logIn
                                ? 'Create An Account'
                                : 'I Already Have Account'),
                          ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
