import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz/funcs.dart';

class Auth {
  static Future<bool> signUp(
      {required context,
      required String email,
      required String password}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      Funcs().showSnackBar(context, e.message ?? "ERROR");
      return false;
    } catch (e) {
      Funcs().showSnackBar(context, "ERROR");
      return false;
    }
  }

  Future<bool> signInWithEmail(String email, String password, context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      Funcs().showSnackBar(context, e.message ?? "ERROR");
      return false;
    } catch (e) {
      Funcs().showSnackBar(context, "ERROR");
      return false;
    }
  }

  Future<bool> logOut(context) async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } on FirebaseAuthException catch (e) {
      Funcs().showSnackBar(context, e.message ?? "ERROR");
      return false;
    } catch (e) {
      Funcs().showSnackBar(context, "ERROR");
      return false;
    }
  }

  String getEMail() {
    return FirebaseAuth.instance.currentUser?.email ?? "";
  }
}
