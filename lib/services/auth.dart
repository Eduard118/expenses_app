import 'package:firebase_auth/firebase_auth.dart';
import 'package:expensesapp/models/user.dart' as  us;


class AuthService{


  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user obj based on FirebaseUser
  us.User _userFromFirebaseUser(User user){
    return  us.User(uid: user.uid);
  }

  //auth change user stream
/*  Stream<us.User> get user{
    return _auth.authStateChanges().map((User user) => us.User(uid: user.uid));
    //.map((FirebaseUser user)=> _userFromFirebaseUser(user));
    //.map(_userFromFirebaseUser);
  }*/


  /*// sign in anon
  Future signInAnon () async{
    try
    {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }
    catch(e)
    {
      ////print(e.toString());
      return null;
    }
  }*/
  // sign in with Email & Password
  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword (email: email, password: password);
      User user;
      if(result.user!= null && result.user!.emailVerified){
        user = result.user!;
        return user;}
      else if(result.user == null){
        ////print('User is null');
        return null;
      }
      else if(!result.user!.emailVerified){
        ////print('User is not verified');
        return false;
      }
    }
    catch(e){
      ////print(e.toString());
      return null;
    }
  }

  // register with Email & Password
  Future<bool> registerWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword (email: email, password: password);
      result.user!.sendEmailVerification();

      if(!result.user!.emailVerified){
        await signOut();
        return true;
      }
      else {
        return false;
      }
    }
    catch(e){
      return false;
    }
  }

  Future<void> sendEmailVerification(String email, String password)async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword (email: email, password: password);
      return result.user!.sendEmailVerification();
    }
    catch(e){
      ////print(e.toString());
      return null;
    }
  }

  // sign out
  Future<bool> signOut() async{
    try{
      await _auth.signOut();
      return true;
    }
    catch(e){
      ////print(e.toString());
      return false;
    }
  }
}