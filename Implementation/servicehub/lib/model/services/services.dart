import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:servicehub/firebase_services.dart';

class ServiceData {
  String uid;
  String sellerUid;
  String title;
  String category;
  String type;
  int price;
  String description;
  String delivaryTime;
  String poster;

  ServiceData({
    required this.uid,
    required this.sellerUid,
    required this.title,
    required this.category,
    required this.type,
    required this.price,
    required this.description,
    required this.delivaryTime,
    required this.poster,
  });

  Map<String, dynamic> toMapService() {
    return {
      'service id': uid,
      'seller id': sellerUid,
      'title': title,
      'category': category,
      'type': type,
      'price': price,
      'description': description,
      'delivary time': delivaryTime,
      'poster': poster,
    };
  }
}

class Services {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;
  final FirebaseServices _services = FirebaseServices();

  // Future<String> addCategory() async {
  //   CollectionReference categories = _firestore.collection('categories');
  //   var result = await categories.doc('Cloud Computing').set({
  //     'name': 'Cloud Computing',
  //     'image': 'assets/undraw_weather_notification.svg'
  //   });
  //   await addServiceType();
  //   return 'success';
  // }

  // Future<String> addServiceType() async {
  //   CollectionReference categories = _firestore.collection('categories');
  //   categories
  //       .doc('Cloud Computing')
  //       .collection('Software As A Service (SaaS)')
  //       .add({
  //     'name': 'Software As A Service (SaaS)',
  //     'image': 'assets/software-as-a-service.png'
  //   });
  //   return 'success';
  // }
  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  // String? _newService;
  // String? get getService => _newService;

  Future<List<String>> getCategories() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('categories').get();
    List<String> categories = querySnapshot.docs.map((doc) => doc.id).toList();
    // print(categories);
    return categories;
  }

  Future<List<String>> getServiceTypes(String category) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('categories')
        .doc(category)
        .collection('serviceTypes')
        .get();

    List<String> serviceTypes =
        querySnapshot.docs.map((doc) => doc.id).toList();
    return serviceTypes;
  }

  Future<String> uploadImageToStorage(String fileName, File file) async {
    firebase_storage.Reference ref =
        _storage.ref().child(fileName).child(uniqueFileName);
    firebase_storage.UploadTask uploadTask = ref.putFile(file);
    firebase_storage.TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> createService({
    required String title,
    required String category,
    required String type,
    required int price,
    required String description,
    required String delivaryTime,
    required File poster,
  }) async {
    String resp = 'Some Error occured';
    try {
      if (title.isNotEmpty &&
          category.isNotEmpty &&
          type.isNotEmpty &&
          description.isNotEmpty &&
          delivaryTime.isNotEmpty) {
        String imageUrl = await uploadImageToStorage('Poster', poster);
        DocumentReference newServiceRef =
            _firestore.collection('services').doc();
        String newServiceUid = newServiceRef.id;
        // _newService = newServiceUid;

        ServiceData serviceData = ServiceData(
            uid: newServiceUid,
            sellerUid: _services.user!.uid,
            title: title,
            category: category,
            type: type,
            price: price,
            description: description,
            delivaryTime: delivaryTime,
            poster: imageUrl);

        await newServiceRef.set(serviceData.toMapService());

        resp = 'success:$newServiceUid';
        print(resp);
      }
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }

  Future<ServiceData?> getServiceById(String serviceId) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('services').doc(serviceId).get();
    print(snapshot);
    if (snapshot.exists) {
      return ServiceData(
        uid: snapshot['service id'],
        sellerUid: snapshot['seller id'],
        title: snapshot['title'],
        category: snapshot['category'],
        type: snapshot['type'],
        price: snapshot['price'],
        description: snapshot['description'],
        delivaryTime: snapshot['delivary time'],
        poster: snapshot['poster'],
      );
    } else {
      return null;
    }
  }
}
