// CRUD operations with firebase

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fundoo_notes/services/my_note_model.dart';

class FirestoreDB {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // static bool hasMoreData = true;
  static DocumentSnapshot? lastDocument;
  /*
  WHAT IS USED IN THE CODE AND WHY AND HOW:-
  FirebaseFirestore.instance.collection("TAKES THE DATABASE WHICH IS TO BE CONSIDERED FOR THE OPERATION").doc("TAKES THE DETAILS OF THE USER, FOR WHOM THE DATA IS TO BE ACCESSED").
  collection("TAKES WHICH SUB-COLLECTION IS TO BE SELECTED").doc("GENERALLY TAKES INTEGER ID/ DOCUMENT ID OF THE DOC TO BE ACCESSED").SELECT THE OPERATION TO BE PERFORMED ACCORDINGLY .
  then("performs the action which is required to be executed after the previous tasks are done");

  NOTE: if the doc id is duplicate it will over-write the data, if its unique, it will create new data
   */

  // CREATE new note method, stored at firebase -> cloud firestore
  static Future<void> createNewNoteFirestore(
      String heading, String content) async {
    final documentRef = _firestore
        .collection("notes")
        .doc(_auth.currentUser!.email)
        .collection("userNotes")
        .doc();

    documentRef.set({
      "id": documentRef.id,
      "Title": heading,
      "content": content,
      "date modified": DateTime.now()
    }).then((_) {
      debugPrint("note added successfully");
    });
  }

  // READ operation
  // static readNote(String id) async {
  //   await _firestore
  //       .collection("notes")
  //       .doc(_auth.currentUser!.email)
  //       .collection("userNotes")
  //       .doc(id)
  //       .get();
  // }

  // UPDATE operation
  static Future<void> updateNote(
      String title, String content, String id) async {
    try {
      await _firestore
          .collection("notes")
          .doc(_auth.currentUser!.email)
          .collection("userNotes")
          .doc(id)
          .update({
        "Title": title,
        "content": content,
        "date modified": DateTime.now()
      }).then((_) => debugPrint("Data modified successfully"));
    } on FirebaseException catch (ex) {
      debugPrint("ERROR UPDATING THE NOTE");
      debugPrint(ex.code.toString());
    }
  }

  // DELETE operation
  static Future<void> deleteNote(String id) async {
    try {
      await _firestore
          .collection("notes")
          .doc(_auth.currentUser!.email)
          .collection("userNotes")
          .doc(id)
          .delete()
          .then((_) => debugPrint("DATA DELETED SUCCESSFULLY"));
    } on FirebaseException catch (ex) {
      debugPrint("ERROR DELETING THE NOTE");
      debugPrint(ex.code.toString());
    }
  }

  // To get particular details from the database
  static Future<List<Note>> getNotesData() async {
    List<Note> notes = [];
    await FirebaseFirestore.instance
        .collection("notes")
        .doc(_auth.currentUser!.email)
        .collection("userNotes")
        .orderBy("date modified", descending: true)
        .get()
        .then((querySnapshot) {
      for (var element in querySnapshot.docs) {
        Map<String, dynamic> noteMap = element.data();
        // debugPrint(noteMap["Title"]);
        final title = noteMap["Title"];
        final content = noteMap["content"];
        final createdTime = noteMap["date modified"];
        final id = noteMap["id"];

        final note = Note(
            id: id,
            pin: false,
            title: title,
            content: content,
            createdTime: createdTime.toString());
        notes.add(note);
      }
    });
    return notes;
  }

  // static Future<List<Note>> getPagination() async{
  //
  //   List<Note> noteslist = [];
  //   DocumentSnapshot? lastDoc;
  //   late QuerySnapshot notesSnap;
  //   bool hasMore = true;
  //   if(hasMore) {
  //     if (lastDoc == null) {
  //       notesSnap =
  //       await _firestore.collection("notes").doc(_auth.currentUser!.email).
  //       collection("userNotes").orderBy("date modified", descending: true)
  //           .limit(10).get()
  //           .then((value) {
  //         for (var element in value.docs) {
  //           Map<String, dynamic> noteMap = element.data();
  //           final title = noteMap["Title"];
  //           final content = noteMap["content"];
  //           final createdTime = noteMap["date modified"];
  //           final id = noteMap["id"];
  //
  //           final note = Note(
  //               id: id,
  //               pin: false,
  //               title: title,
  //               content: content,
  //               createdTime: createdTime.toString());
  //           noteslist.add(note);
  //           lastDoc = notesSnap.docs.last;
  //           noteslist.add(notesSnap.docs as Note);
  //         }
  //         return notesSnap;
  //       });
  //     }else{
  //       notesSnap = await _firestore.collection("notes").doc(_auth.currentUser!.email).
  //       collection("userNotes").orderBy("date modified", descending: true)
  //           .limit(10).startAfterDocument(lastDoc).get()
  //           .then((value) {
  //         for (var element in value.docs) {
  //           Map<String, dynamic> noteMap = element.data();
  //           final title = noteMap["Title"];
  //           final content = noteMap["content"];
  //           final createdTime = noteMap["date modified"];
  //           final id = noteMap["id"];
  //
  //           final note = Note(
  //               id: id,
  //               pin: false,
  //               title: title,
  //               content: content,
  //               createdTime: createdTime.toString());
  //           noteslist.add(note);
  //           lastDoc = notesSnap.docs.last;
  //           noteslist.add(notesSnap.docs as Note);
  //         }
  //         return notesSnap;
  //       });
  //     }
  //     if(notesSnap.docs.length <10){
  //       hasMore = false;
  //     }
  //   }
  //   return noteslist;
  // }

  static Future<List<Note>> searchNotes(String searchText) async {
    List<Note> notes = [];
    await _firestore
        .collection("notes")
        .doc(_auth.currentUser!.email)
        .collection("userNotes")
        .orderBy("date modified", descending: true)
        .get()
        .then((querySnapshot) {
      for (var element in querySnapshot.docs) {
        Map noteMap = element.data();
        // debugPrint(noteMap["Title"]);
        final title = noteMap["Title"];
        final content = noteMap["content"];
        final createdTime = noteMap["date modified"];
        final id = noteMap["id"];

        if (title.toString().contains(searchText) ||
            content.toString().contains(searchText)) {
          final note = Note(
              id: id,
              pin: false,
              title: title,
              content: content,
              createdTime: createdTime.toString());
          notes.add(note);
        }
      }
    });
    return notes;
  }

  // FOR ARCHIVED NOTES
  //  CREATE ARCHIVE NOTE
  /*
  SELECTING THE PARTICULAR NOTE AND ADDING IT TO A DIFFERENT COLLECTION
  NAMED userArchivedNotes, TAKING HEADING, CONTENT AND DOC ID AS THE PARAMETERS,
  ALSO DELETING THE SAME NOTE FROM THE userNotes COLLECTION
   */
  static Future<void> archiveNote(
      String heading, String content, String id) async {
    final documentRef = _firestore
        .collection("notes")
        .doc(_auth.currentUser!.email)
        .collection("userArchivedNotes")
        .doc();
    documentRef.set({
      "id": documentRef.id,
      "Title": heading,
      "content": content,
      "date modified": DateTime.now()
    }).then((_) {
      FirestoreDB.deleteNote(id)
          .then((_) => debugPrint("NOTE ARCHIVED AND REMOVED FROM MAIN LIST"));
    });
  }

  // UN- ARCHIVE NOTE
  static Future<void> unArchiveNote(
      String heading, String content, String noteID) async {
    final docRef = _firestore
        .collection("notes")
        .doc(_auth.currentUser!.email)
        .collection("userNotes")
        .doc();
    docRef.set({
      "id": docRef.id,
      "Title": heading,
      "content": content,
      "date modified": DateTime.now()
    }).then((_) {
      debugPrint("UN-ARCHIVED NOTE");
      FirestoreDB.deleteArchivedNote(noteID);
      debugPrint("ARCHIVED NOTE DELETED FROM COLLECTION");
    });
  }

  // DELETE ARCHIVED NOTE
  static Future<void> deleteArchivedNote(String id) async {
    try {
      await _firestore
          .collection("notes")
          .doc(_auth.currentUser!.email)
          .collection("userArchivedNotes")
          .doc(id)
          .delete()
          .then((_) => debugPrint("DATA DELETED SUCCESSFULLY"));
    } on FirebaseException catch (ex) {
      debugPrint("ERROR DELETING THE NOTE");
      debugPrint(ex.code.toString());
    }
  }

  // READ THE ARCHIVED NOTE
  static Future<List<Note>> fetchArchiveNotes() async {
    List<Note> notes = [];
    await _firestore
        .collection("notes")
        .doc(_auth.currentUser!.email)
        .collection("userArchivedNotes")
        .orderBy("date modified", descending: true)
        .get()
        .then((querySnapshot) {
      for (var element in querySnapshot.docs) {
        Map noteMap = element.data();
        debugPrint(noteMap["Title"]);
        final title = noteMap["Title"];
        final content = noteMap["content"];
        final createdTime = noteMap["date modified"];
        final id = noteMap["id"];

        final note = Note(
            id: id,
            pin: false,
            title: title,
            content: content,
            createdTime: createdTime.toString());
        notes.add(note);
      }
    });
    return notes;
  }

  static Future<void> userFeedBack(String message) async {
    final docRef = await _firestore
        .collection("notes")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("userFeedback")
        .doc();
    docRef.set({"id": docRef.id, "feedback": message, "time": DateTime.now()});
  }

  // static Future<void> reminderNotes(String heading, String content, String id) async{
  //   final docRef = await _firestore.collection("userNotes").doc(_auth.currentUser!.email).collection("reminderNotes").doc();
  //   docRef.set({
  //     "id": docRef.id,
  //     "title": heading,
  //     "content": content,
  //     "date" : DateTime.now()
  //   });
  // }
  // static Future<void> getReminderNotes(String id) async{
  //   List<Note> reminderNotes = [];
  //   final docRef =
  // }
}



