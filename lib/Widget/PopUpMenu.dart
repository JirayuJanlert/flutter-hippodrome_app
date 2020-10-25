import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



Widget myPopMenu(context, _googleSignIn, _auth, central) {
  final act = CupertinoActionSheet(
    title: Text("Menu"),
    message: Text("Select any action "),
    actions: <Widget>[
      CupertinoActionSheetAction(
        child: Text("Sign out"),
        isDefaultAction: true,
        onPressed: () {
          central.changeSelectedCategories(0);
          central.signOutfromApp( _googleSignIn, _auth, context);
        },
      ),
      CupertinoActionSheetAction(
        child: Text("cancel"),
        isDestructiveAction: true,
        onPressed: () {
          Navigator.pop(context);
        },
      )
    ],
  );
  if (Platform.isAndroid) {
    return PopupMenuButton(
        icon: Icon(Icons.more_horiz),
        onSelected: (value) {
          if (value == 3) {
            print("3");
            central.changeSelectedCategories(0);
central.signOutfromApp(_googleSignIn, _auth, context);
          }
        },
        itemBuilder: (context) =>
        [
          PopupMenuItem(
              value: 1,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                    child: Icon(Icons.print, color: Colors.black,),
                  ),
                  Text('Print')
                ],
              )),
          PopupMenuItem(
              value: 2,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                    child: Icon(Icons.share, color: Colors.black),
                  ),
                  Text('Share')
                ],
              )),
          PopupMenuItem(
              value: 3,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                    child: Icon(Icons.exit_to_app, color: Colors.black),
                  ),
                  Text('SignOut')
                ],
              )),
        ]);
  }
  return IconButton(icon: Icon(Icons.more_horiz), onPressed: (){
    showCupertinoModalPopup(
        context: context,
        builder: (context) => act  //action is final variable name
    );
  });
}

