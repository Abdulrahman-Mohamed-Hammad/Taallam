import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:student_app/core/Auth/data/Model/model_auth.dart';
import 'package:student_app/core/data/Model/add_subject-model.dart';
import 'package:student_app/core/go_router.dart';

enum CollectionPath { subjects, lessons, practes, progress }

class FirebaseHelper {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _fireauth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  static FirebaseAuth get fireauth => _fireauth;
  static GoogleSignIn get googleSignIn => _googleSignIn;

  static String? checkUser() {
    if (_fireauth.currentUser == null) return null;
    return "";
  }

  static Future<void> logout() async {
    await fireauth.signOut();
  }

  static Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _fireauth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
    }
  }

  static Future<int?> googleSignIN() async {
    try {
      var response = await _googleSignIn.authenticate();

      await fireauth.signInWithCredential(
        GoogleAuthProvider.credential(idToken: response.authentication.idToken),
      );
      return null;
    } catch (e) {
      log(e.toString());
      return 0;
    }
  }

  static Future<void> addCollection(
    String collectionName,
    TheMainModel model,
  ) async {
    try {
      var doc = _firestore.collection(collectionName).doc();
      model.id = doc.id;
      await doc.set(model.toJson());
    } catch (e) {
      print('Error adding collection: $e');
    }
  }

  static Future<List<Map<String, dynamic>>?> getCollection(
    String collectionName, [
    bool where = false,
  ]) async {
    try {
      Query query = _firestore.collection(collectionName);
      if (where) {
        query = query.where("lock", isEqualTo: false);
      }

      QuerySnapshot snapshot = await query.get(
        const GetOptions(source: Source.server),
      );

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      return null;
    }
  }

  static Future<int?> updateLessonStatusAndSubject(
    String collectionName,
    String docId,
    String subCollectionName,
    String lessonId,
    bool isCompleted,
    int progress,
    int lessonsCount,
    String next,
  ) async {
    WriteBatch batch = FirebaseHelper._firestore.batch();

    DocumentReference subjectUpdate = FirebaseHelper._firestore
        .collection(collectionName)
        .doc(docId)
        .collection(getCollectionPath(CollectionPath.progress))
        .doc(_fireauth.currentUser!.uid);

    DocumentReference lessonUpdate = FirebaseHelper._firestore
        .collection(collectionName)
        .doc(docId)
        .collection(subCollectionName)
        .doc(lessonId)
        .collection(getCollectionPath(CollectionPath.progress))
        .doc(_fireauth.currentUser!.uid);

    batch.set(lessonUpdate, {
      'isCompleted': isCompleted,
    }, SetOptions(merge: true));
    batch.set(subjectUpdate, {
      'progress': progress,
      "isCompleted": progress == lessonsCount ? true : false,
    }, SetOptions(merge: true));
    if (progress == lessonsCount && next.isNotEmpty) {
      DocumentReference subjectUpdateNext = FirebaseHelper._firestore
          .collection(collectionName)
          .doc(next)
          .collection(getCollectionPath(CollectionPath.progress))
          .doc(_fireauth.currentUser!.uid);
      batch.set(subjectUpdateNext, {'isLock': false}, SetOptions(merge: true));
    }

    try {
      await batch.commit();

      return 1;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> getSubCollection(
    String collectionName,
    String docId,
    String subCollectionName,
  ) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(collectionName)
          .doc(docId)
          .collection(subCollectionName)
          .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error getting sub collection: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getCollectionGroup(
    String collectionName,
  ) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collectionGroup(collectionName)
          .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error getting sub sub collection: $e');
      return [];
    }
  }

  static Future<String?> register(AuthRequestModel model) async {
    try {
      var response = await _fireauth.createUserWithEmailAndPassword(
        email: model.email,
        password: model.password,
      );
      await response.user?.updateDisplayName(model.fullName);

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  static Future<String?> login(AuthRequestModel model) async {
    try {
      log("email: ${model.email}");
      log("password: ${model.password}");
      await _fireauth.signInWithEmailAndPassword(
        email: model.email,
        password: model.password,
      );
      log("message");
      return null;
    } on FirebaseAuthException catch (e) {
      log("error ${e.code}");
      log("error ${e.message}");
      return e.message;
    }
  }

  static Future<void> progressSubject(SubjectModel subject, bool isLock) async {
    try {
      final progressRef = _firestore
          .collection(getCollectionPath(CollectionPath.subjects))
          .doc(subject.id!)
          .collection(getCollectionPath(CollectionPath.progress));

      final doc = await progressRef.doc(_fireauth.currentUser!.uid).get();
      if (!doc.exists) {
        await progressRef.doc(_fireauth.currentUser!.uid).set({
          "isLock": isLock,
          "isCompleted": false,
          "progress": 0,
        }, SetOptions(merge: true));
        subject.lock = isLock;
        subject.isCompleted = false;
        subject.progress = 0;
        return;
      }
      subject.updateProgress(doc.data()!);
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<void> progressLesson(
    SubjectModel subject,
    LessonsModel lesson,
  ) async {
    try {
      final progressRef = _firestore
          .collection(getCollectionPath(CollectionPath.subjects))
          .doc(subject.id!)
          .collection(getCollectionPath(CollectionPath.lessons))
          .doc(lesson.id!)
          .collection(getCollectionPath(CollectionPath.progress));

      final doc = await progressRef.doc(_fireauth.currentUser!.uid).get();
      if (!doc.exists) {
        await progressRef.doc(_fireauth.currentUser!.uid).set({
          "isCompleted": false,
        }, SetOptions(merge: true));
        lesson.isCompleted = false;
        return;
      }
      lesson.updateProgress(doc.data()!);
    } catch (e) {
      log(e.toString());
    }
  }

  static String getCollectionPath(CollectionPath collectionPath) {
    switch (collectionPath) {
      case CollectionPath.subjects:
        return "Subject";
      case CollectionPath.lessons:
        return "Lessons";
      case CollectionPath.practes:
        return "Practes";
      case CollectionPath.progress:
        return "Progress";
    }
  }
}
