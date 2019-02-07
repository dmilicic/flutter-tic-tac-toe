import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class GameInfoRepository {

  static const String VICTORIES_DOC_NAME = "victories";
  static const String FIELD_COUNT = "count";
  static GameInfoRepository _victoryRepository;

  DocumentSnapshot _documentCache;

  static GameInfoRepository getInstance() {
    if (_victoryRepository == null) {
      _victoryRepository = GameInfoRepository();
    }

    return _victoryRepository;
  }

  Stream getVictoryStream() {
    return Firestore.instance.collection(VICTORIES_DOC_NAME).snapshots();
  }

  /// Reactive getter for victory count
  int getVictoryCount(AsyncSnapshot<dynamic> snapshot) {
    if (snapshot.hasData) {
      _documentCache = _getDocument(snapshot.data);
      return _documentCache.data[FIELD_COUNT];
    }

    return -1;
  }

  /// Async setter for adding the victory count
  void addVictory() async {
    Firestore.instance.runTransaction((transaction) async {
      DocumentReference reference = _documentCache.reference;
      DocumentSnapshot docSnapshot = await transaction.get(reference);
      await transaction.update(docSnapshot.reference, {
        FIELD_COUNT: docSnapshot.data[FIELD_COUNT] + 1,
      });
    });
  }

  DocumentSnapshot _getDocument(QuerySnapshot snapshot) {
    return snapshot.documents[0];
  }
}