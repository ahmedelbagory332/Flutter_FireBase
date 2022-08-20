import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/edit_screen.dart';
import 'package:image_picker/image_picker.dart';
import '../fireBaseHelper.dart';
import 'Utils.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({Key? key}) : super(key: key);

  @override
  ItemsScreenState createState() => ItemsScreenState();
}

class ItemsScreenState extends State<ItemsScreen> {
  late BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Items"),
        ),
        body: StreamBuilder(
          stream:  FireBaseHelper().getItems(),
          builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
            if (snapshot.hasError) {
              return const Text('Something went wrong try again');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return snapshot.data!.size == 0?
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Center(child: Text('No items')),
              ],
            ):ListView.builder(
                reverse: true,
                shrinkWrap: true ,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index){
                  var itemId = snapshot.data!.docs[index]['itemId'].toString();
                  return  Card(
                    child: SizedBox(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: FadeInImage.assetNetwork(
                                placeholder: 'images/Fading lines.gif',
                                image: snapshot.data!.docs[index]['photo'].toString(),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Column(
                              children: [
                                Text(snapshot.data!.docs[index]['name'].toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                                ),
                                Text("${snapshot.data!.docs[index]['price']} LE",)
                              ],
                            ),
                          ),
                          Row(
                            children: [
                                InkWell(
                                  onTap: ()  {
                                   FirebaseFirestore.instance
                                        .collection('items')
                                        .get().then((querySnapshot){
                                     Navigator.push(
                                       context,
                                       MaterialPageRoute(builder: (context) =>  EditScreen(querySnapshot.docs,itemId)),
                                     );

                                   });
                                  },
                                  child: const Padding(
                                    padding:  EdgeInsets.symmetric(horizontal: 20),
                                    child: Icon(Icons.edit,color: Colors.blue,),
                                  ),
                                ),
                              InkWell(
                                onTap: (){
                                  FirebaseFirestore.instance
                                      .collection('items')
                                      .get().then((querySnapshot){
                                    for (var doc in querySnapshot.docs) {

                                      if(doc["itemId"].toString().trim() == itemId.toString().trim()){
                                        FireBaseHelper().deleteItem(context: context, documentId: doc.id);
                                        return;
                                      }

                                    }

                                  });
                                  
                                },
                                  child: const Padding(
                                    padding:  EdgeInsets.symmetric(horizontal: 20),
                                    child:  Icon(Icons.delete,color: Colors.red,),
                                  ),
                                ),
                              ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
            );
          },
        )
      ),
    );
  }



}