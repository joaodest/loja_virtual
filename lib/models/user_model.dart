import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';


class UserModel extends Model {
 final FirebaseAuth _auth = FirebaseAuth.instance;

  User? firebaseUser;
  User? currentUser;

  Map<String, dynamic>? userData = {};

  bool isLoading = false;

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
      _loadCurrentUser();

  }

  void signUp  ({
        required Map<String, dynamic> userData,
        required String pass,
        required VoidCallback onSuccess,
        required VoidCallback onFail}) {

    isLoading = true;
    notifyListeners();
    _auth
        .createUserWithEmailAndPassword(email: userData['email'], password: pass)
        .then((user) async {
      firebaseUser = user.user;

     await _saveUserData(userData);

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e){
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signIn({
    required String email,
    required String pass,
    required VoidCallback onSuccess,
    required VoidCallback onFail
  }) async {

    isLoading = true;
    notifyListeners();

    _auth.signInWithEmailAndPassword(
        email: email,
        password: pass
    ).then((user) async {
      firebaseUser = user.user;

      await _loadCurrentUser();

      onSuccess();
      isLoading = false;
      notifyListeners();

    }).catchError((e){
      onFail();
      isLoading = false;
      notifyListeners();
    });

  }

  void recoverPass(String email){
    _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async{
    this.userData = userData;
   await FirebaseFirestore.instance
       .collection('user')
       .doc(firebaseUser!.uid)
       .set(userData);
  }

  bool isLoggedIn(){

    return firebaseUser != null;
  }

  void signOut() async {
   await _auth.signOut();
   userData = {};
   firebaseUser = null;
   notifyListeners();
  }

  Future<void> _loadCurrentUser() async {
    firebaseUser ??= _auth.currentUser;
    if (firebaseUser != null) {
      DocumentSnapshot<Map<String, dynamic>> docUser = await FirebaseFirestore
          .instance
          .collection('user')
          .doc(firebaseUser!.uid)
          .get();
      userData = docUser.data.call();
    }
    notifyListeners();
  }
}