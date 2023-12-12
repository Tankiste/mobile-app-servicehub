import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:servicehub/firebase_services.dart';

class Services {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;
  final FirebaseServices _services = FirebaseServices();

  Future<String> addCategory() async {
    CollectionReference categories = _firestore.collection('categories');
    var result = await categories.doc('Digital Marketing and E-commerce').set({
      'name': 'Digital Marketing and E-commerce',
      'image': 'assets/undraw_add_to_cart.svg'
    });
    await addServiceType();
    return 'success';
  }

  Future<String> addServiceType() async {
    CollectionReference categories = _firestore.collection('categories');
    categories
        .doc('Digital Marketing and E-commerce')
        .collection('E-commerce Development and Management')
        .add({
      'name': 'E-commerce Development and Management',
      'image': 'assets/e-commerce-management.png'
    });
    return 'success';
  }
}
