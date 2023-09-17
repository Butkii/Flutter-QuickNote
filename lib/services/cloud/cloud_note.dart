import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:QuickNote/services/cloud/cloud_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;
  final String title;

  const CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.title,
    required this.text,
  });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldName] as String,
        title = snapshot.data()[titleFieldName] as String;
}
