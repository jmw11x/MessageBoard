// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jwilson177hw1/models/user.dart';

class AdminAlert {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final CollectionReference messages =
      Firestore.instance.collection('messages');
  final Query messages1 =
      Firestore.instance.collection('messages').orderBy('datetime');
  final CollectionReference users = Firestore.instance.collection('users');
  final CollectionReference boards = Firestore.instance.collection('Boards');

  Future<String> getUser() async {
    FirebaseUser uid = await _auth.currentUser();
    String user_id = uid.uid.toString();
    DocumentSnapshot ds = await users.document(user_id).get();
    String name = ds.data['firstName'].toString();
    return name;
  }

  Future<String> getsocial() async {
    FirebaseUser uid = await _auth.currentUser();
    String user_id = uid.uid.toString();
    DocumentSnapshot ds = await users.document(user_id).get();
    String name = ds.data['social'].toString();
    return name;
  }

  Future<String> currentuid() async {
    FirebaseUser uid = await _auth.currentUser();
    String user_id = uid.uid.toString();
    return user_id;
  }

  Future<String> getUsersAsString() async {
    String registered = '';
    await users.getDocuments().then((message) {
      message.documents.forEach((value) {
        if (value['firstName'] != null) {
          registered =
              registered + value.documentID + ", " + value['firstName'] + "\n";
        }
      });
    });
    return registered;
  }

  Future<String> getBoardsAsString() async {
    String avaialble = '';
    await boards.getDocuments().then((message) {
      message.documents.forEach((value) {
        if (value['name'] != null) {
          avaialble = avaialble + value['name'] + "\n";
        }
      });
    });
    return avaialble;
  }

  Future<bool> chatExists(String other, String current) async {
    final snapshot =
        await Firestore.instance.collection(other + current).getDocuments();
    final snapshot1 =
        await Firestore.instance.collection(current + other).getDocuments();
    if (snapshot.documents.length == 0) {
      return false;
    }
    return true;
  }

  Future<bool> chatExists1(String other, String current) async {
    final snapshot =
        await Firestore.instance.collection(other + current).getDocuments();
    final snapshot1 =
        await Firestore.instance.collection(current + other).getDocuments();
    if (snapshot.documents.length == 0 || snapshot1.documents.length == 0) {
      return false;
    }
    return true;
  }

  Future<String> getMessagesAsString(String current) async {
    String msgs = '';
    // print(current);
    final Query chats1 =
        Firestore.instance.collection(current).orderBy('datetime');
    // print(current);
    await chats1.getDocuments().then((message) {
      message.documents.forEach((value) {
        // print("54" + value["message"]);
        if (value["Message"] != null)
          msgs = msgs + value["author"] + "->" + (value['Message']) + "\n";
        // print(msgs);
      });
    });
    return msgs;
  }

  Future addAdminMessage(String message, String current, String name) async {
    await Firestore.instance.collection(current).document().setData({
      'Message': message,
      'datetime': DateTime.now().toLocal().toString(),
      'author': name
    });
  }

  Future updateProfile(String first, String current, String last) async {
    await Firestore.instance.collection(current).document().updateData({
      'firstName': first,
      'lastname': last,
    });
  }

  Future updatesocial(String social, String current) async {
    await Firestore.instance.collection('users').document(current).updateData({
      'social': social,
    });
  }

  Future<void> updateEmail(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }
}
