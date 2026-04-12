import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<AppUser?> get user {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return null;
      return AppUser.fromMap(doc.data()!);
    });
  }

  Future<AppUser?> signInWithEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _getUser(cred.user!.uid);
  }

  Future<AppUser?> signUpWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user!;
    await user.updateDisplayName(displayName);
    final appUser = AppUser(
      uid: user.uid,
      email: user.email!,
      displayName: displayName,
      createdAt: DateTime.now(),
    );
    await _firestore.collection('users').doc(user.uid).set(appUser.toMap());
    return appUser;
  }

  Future<AppUser?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;
    final cred = await _auth.signInWithCredential(
      GoogleAuthProvider.credential(
        idToken: await googleUser.authentication.then((a) => a.idToken),
        accessToken: await googleUser.authentication.then((a) => a.accessToken),
      ),
    );
    final user = cred.user!;
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) {
      final appUser = AppUser(
        uid: user.uid,
        email: user.email!,
        displayName: user.displayName ?? googleUser.displayName ?? 'User',
        photoURL: user.photoURL ?? googleUser.photoUrl,
        createdAt: DateTime.now(),
      );
      await _firestore.collection('users').doc(user.uid).set(appUser.toMap());
      return appUser;
    }
    return AppUser.fromMap(doc.data()!);
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  Future<AppUser?> _getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(doc.data()!);
  }
}
