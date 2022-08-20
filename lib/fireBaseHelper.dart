import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Utils.dart';


class FireBaseHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;

  //SIGN UP METHOD
  Future signUp({required String email, required String password}) async {
    try {
      var userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user !=null) {
        return "true";
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN IN METHOD
  Future signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if(user != null) {
        return "Welcome";
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN OUT METHOD
  Future signOut() async {
    await _auth.signOut();
  }

  UploadTask getRefrenceFromStorage(file){
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("Media")
        .child(file!.name);
    return ref.putFile(File(file.path));

  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getItems() {
    return FirebaseFirestore.instance.collection('items').snapshots();
  }


  void deleteItem({required BuildContext context,required String documentId}) {
      FirebaseFirestore
          .instance.collection('items')
          .doc(documentId)
          .delete()
          .whenComplete(() => buildShowSnackBar(context, "Item deleted"));
  }



}