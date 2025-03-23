import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ✅ Generate Mocks for Firebase Services
@GenerateMocks([FirebaseAuth, FirebaseFirestore, FirebaseApp])
void main() {}
