import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../controllers/country.dart';
import 'package:firebase_core/firebase_core.dart';

class CountryDetails extends StatefulWidget {
  const CountryDetails({Key? key, required this.title, required this.country})
      : super(key: key);

  final String title;
  final String country;

  @override
  State<CountryDetails> createState() => _CountryDetailsState();
}

class _CountryDetailsState extends State<CountryDetails> {
  @override
  Widget build(BuildContext context) {

    CollectionReference countries =
        FirebaseFirestore.instance.collection('world-cities');


    return FutureBuilder<DocumentSnapshot>(
      future: countries.doc(widget.country).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: SingleChildScrollView(

                child: Column(children: [
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    shrinkWrap: true,
                    itemCount: data[widget.country]
                        .length, //data['Afghanistan'].length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: ListTile(
                          title: Text(
                              data[widget.country][index]['name'].toString()),
                          subtitle: Text(data[widget.country][index]
                                  ['subcountry']
                              .toString()),
                        ),
                      );
                    },
                  )

                  /*
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                          "Full Name: ${data['Andorra'][0]['name']}"), // ${data['last_name']}")
                    ],*/
                ])),
          );
        }

        return Container(
          color: Colors.white,
          alignment: Alignment.center,
          height: 50,
          width: 50,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );
      },
    );

  }
}
