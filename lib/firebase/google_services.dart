import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn googleSignIn = GoogleSignIn();

String? googleName;
String? googleEmail;
String? googleImageUrl;

/// GOOGLE LOGIN WITH FIREBASE

Future<String> signInWithGoogle() async {
  signOutGoogle();
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken);

  UserCredential authResult =
      await FirebaseAuth.instance.signInWithCredential(credential);
  User? user = authResult.user;

  googleName = user!.displayName;
  googleEmail = user.email;
  googleImageUrl = user.photoURL;

  final User? currentUser = FirebaseAuth.instance.currentUser;
  assert(user.uid == currentUser!.uid);

  print('signInWithGoogle succeeded: $user');
  return '$user';
}

/// FACEBOOK LOGOUT WITH FIREBASE

Future<void> signOutGoogle() async {
  await googleSignIn.signOut();

  print("User Signed Out");
}
