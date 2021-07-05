import 'package:flutter/material.dart';
import 'package:jwilson177hw1/services/adminalert.dart';
import 'package:jwilson177hw1/services/auth.dart';
import 'package:link_text/link_text.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String uid = '';
  String firstName = '';
  String social = "";
  String lastName = '';
  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    AdminAlert db = new AdminAlert();

    Future<String> uzr = db.currentuid();
    uzr.then((value) => setState(() {
          uid = value;
        }));
    Future<String> soc = db.getsocial();
    soc.then((value) => setState(() {
          social = value;
        }));
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        elevation: 0.0,
        title: Text('Profile Settings'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                validator: (v) => v!.isEmpty ? 'cannot leave empty' : null,
                decoration: InputDecoration(
                    hintText: 'firstname', helperText: 'Change first name'),
                onChanged: (v) => {setState(() => firstName = v)},
              ),
              TextFormField(
                validator: (v) => v!.isEmpty ? 'cannot leave empty' : null,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'last name', helperText: 'reset last name'),
                onChanged: (v) => {setState(() => lastName = v)},
              ),
              ElevatedButton(
                  child: Text('Reset Name'),
                  onPressed: () async {
                    await db.updateProfile(firstName, uid, lastName);
                  }),
              LinkText(
                social,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
