import 'package:firebase_auth/firebase_auth.dart';
import 'package:text1/models/app_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

//modifying the user object to get only the uid
  AppUser? _appUserFromFirebase(User? user) {
    if (user == null) {
      return null;
    } else {
      return AppUser(
        uid: user.uid,
      );
    }
  }

  //cansumer stream
  Stream<AppUser?> get appUser {
    return _auth.authStateChanges()
        .map((User? user) => _appUserFromFirebase(user));
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