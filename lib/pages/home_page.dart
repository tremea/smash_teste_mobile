import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../controllers/country.dart';
import 'package:firebase_core/firebase_core.dart';

import 'country_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool carregado = false;

  @override
  void initState() {
    super.initState();
    //getCountries(callbackCountries);
    getCountriesFB(loading);
  }

  callbackCountries(dynamic retorno) {
    log('Retorno: ' + retorno.toString());
  }

  loading() {
    setState(() {
      carregado = true;
    });
  }

  var docsList;
  getCountriesFB(callback) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("world-cities").get();
    docsList = querySnapshot.docs.map((doc) => doc.data()).toList();
    callback();
  }

  @override
  Widget build(BuildContext context) {
    return !carregado
        ? Container(
            color: Colors.white,
            alignment: Alignment.center,
            height: 50,
            width: 50,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          )
        : Scaffold(
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
                itemCount: docsList.length, //data['Afghanistan'].length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: ListTile(
                      trailing: Icon(Icons.keyboard_arrow_right),
                      title: Text(docsList[index]
                          .keys
                          .toString()
                          .replaceAll(')', '')
                          .replaceAll('(', '')),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CountryDetails(
                                  title: "Detalhes",
                                  country: docsList[index]
                                      .keys
                                      .toString()
                                      .replaceAll(')', '')
                                      .replaceAll('(', ''))));
                    },
                  );
                },
              )
            ])),
          );
  }
}
