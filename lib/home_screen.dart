import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../fireBaseHelper.dart';
import 'Utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String name = "";
  String price = "";
  late BuildContext dialogContext;
  final ImagePicker _picker = ImagePicker();
  XFile? photo;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Item"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  FireBaseHelper().signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      'login', (Route<dynamic> route) => false);
                },
                icon: const Icon(Icons.logout_sharp))
          ],
        ),
        body: ListView(
         scrollDirection: Axis.vertical,
          children:  [
             Padding(
               padding:  const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                   SizedBox(
                     width: MediaQuery.of(context).size.width*.4,
                     child: TextField(
                       onChanged: (text) {
                         name = text;
                       },
                       decoration: InputDecoration(
                         labelText: 'Name',
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(10),
                         ),
                       ),
                     ),
                   ),
                   SizedBox(
                     width: MediaQuery.of(context).size.width*.4,
                     child: TextField(
                       onChanged: (text) {
                        price = text;
                       },
                       decoration: InputDecoration(
                         labelText: 'Price',
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(10),
                         ),
                       ),
                     ),
                   ),
                 ],
               ),
             ),
             InkWell(
               onTap: () async {
                   _picker.pickImage(source: ImageSource.camera).then((value){
                     setState(() {
                     photo = value;
                    });
                 });
         },
                 child: photo == null? const Center(child: Text("No image selected.")):
                 Center(
                   child: SizedBox(
                     width: 300,
                       height: 300,
                       child: Image.file(File(photo!.path))),
                 )
             ),

            Padding(
              padding:  const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.indigoAccent,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: TextButton(
                      onPressed: () {
                        if(name.isEmpty || price.isEmpty || photo==null ){
                          buildShowSnackBar(context, "please check your info.");
                        }else{
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                dialogContext = context;
                                return  const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                          );
                          UploadTask uploadTask = FireBaseHelper().getRefrenceFromStorage(photo);
                          uploadTask.then((fileUrl){
                            fileUrl.ref.getDownloadURL().then((url){
                              FirebaseFirestore.instance
                                  .collection('items')
                                  .doc("${Timestamp.now().millisecondsSinceEpoch}")
                                  .set({
                                'itemId': Random().nextInt(99999999),
                                'name': name,
                                'price': price,
                                'photo': url,
                              }).whenComplete(() {
                                Navigator.pop(dialogContext);
                                buildShowSnackBar(context, "Item Added");

                              });
                          });
                       });
                          
                        }
                      },
                      child: const Text(
                        'Add Item',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.indigoAccent,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'items');
                      },
                      child: const Text(
                        'Show Items',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}