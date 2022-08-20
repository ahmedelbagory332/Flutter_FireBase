import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../fireBaseHelper.dart';
import 'Utils.dart';

class EditScreen extends StatefulWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
  final String itemId;
  const EditScreen(this.docs, this.itemId,{Key? key}) : super(key: key);

  @override
  EditScreenState createState() => EditScreenState();
}

class EditScreenState extends State<EditScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  late BuildContext dialogContext;
  final ImagePicker _picker = ImagePicker();
  XFile? photo;
  String itemImageUrl = "";
  String documentId = "";
  @override
  void initState() {
   setState(() {
     for (var doc in widget.docs) {

       if(doc["itemId"].toString().trim() == widget.itemId.toString().trim()){
          itemImageUrl = doc["photo"].toString().trim();
          nameController.text = doc["name"].toString().trim();
          priceController.text = doc["price"].toString().trim();
          documentId = doc.id;
          return;
       }

     }
   });
    super.initState();
  }




  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Update Item"),
          automaticallyImplyLeading: false,
        ),
        body:   ListView(
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
                      controller: nameController,
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
                      controller: priceController,
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
                child: photo == null?
                SizedBox(
                  width: 300,
                  height: 300,
                  child: FadeInImage.assetNetwork(
                    placeholder: 'images/Fading lines.gif',
                    image: itemImageUrl,
                  ),):
                Center(
                  child: SizedBox(
                      width: 300,
                      height: 300,
                      child: Image.file(File(photo!.path)
                      )),
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
                        if(nameController.text.isEmpty || priceController.text.isEmpty){
                          buildShowSnackBar(context, "please check your info.");
                        }else if(nameController.text.isNotEmpty && priceController.text.isNotEmpty && photo==null ){

                          FirebaseFirestore.instance
                              .collection('items')
                              .doc(documentId)
                              .update({
                            'name': nameController.text.toString(),
                            'price': priceController.text.toString(),
                          }).then((_){
                            Navigator.pop(dialogContext);
                            buildShowSnackBar(context, "update name and price");
                          });

                        }else if(nameController.text.isNotEmpty && priceController.text.isNotEmpty && photo!=null ){
                          UploadTask uploadTask = FireBaseHelper().getRefrenceFromStorage(photo);
                          uploadTask.then((fileUrl){
                            fileUrl.ref.getDownloadURL().then((url){
                              FirebaseFirestore.instance
                                  .collection('items')
                                  .doc(documentId)
                                  .update({
                                "name": nameController.text.toString(),
                                "price": priceController.text.toString(),
                                "photo": url,
                              }).then((_){
                                Navigator.pop(dialogContext);
                                buildShowSnackBar(context, "update name and price and image");
                              });

                            });
                          });

                        }
                      },
                      child: const Text(
                        'Update Item',
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