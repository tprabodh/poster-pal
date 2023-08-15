import 'package:firebase_auth/firebase_auth.dart';
import 'package:text1/models/consumer.dart';
import 'package:text1/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Cansumer? _consumerFromFirebase(User? user) {
    if (user == null) {
      return null;
    } else {
      return Cansumer(
        uid: user.uid,
        // Other properties of the Patient object.
      );
    }
  }

  Stream<Cansumer?> get consumer {
    return _auth.authStateChanges()
        .map((User? user) => _consumerFromFirebase(user));
  }



  Future registerWithEmailAndPassword(String email, String password, String userName ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      //create a new document for the patient with uid
      await DatabaseService(uid: user!.uid).updateConsumerData(userName,[] );
      return _consumerFromFirebase(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }



  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

}