import 'package:firebase_auth/firebase_auth.dart';
import 'package:text1/models/consumer.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

//modifying the user object to get only the uid
  Cansumer? _consumerFromFirebase(User? user) {
    if (user == null) {
      return null;
    } else {
      return Cansumer(
        uid: user.uid,
      );
    }
  }

  //cansumer stream
  Stream<Cansumer?> get consumer {
    return _auth.authStateChanges()
        .map((User? user) => _consumerFromFirebase(user));
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

}