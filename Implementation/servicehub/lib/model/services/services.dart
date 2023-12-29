import 'dart:io';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
// import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:servicehub/firebase_services.dart';
import 'package:servicehub/model/app_state.dart';
import 'package:servicehub/model/auth/user_data.dart';

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
  List<String>? likes;

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
    // this.likes,
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
      'likes': likes,
    };
  }
}

class Services {
  // final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;
  final FirebaseServices _services = FirebaseServices();
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  ApplicationState appState = ApplicationState();

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
          poster: imageUrl,
        );

        serviceData.likes = [];

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
        // likes: snapshot['likes'],
      );
    } else {
      return null;
    }
  }

  Future<UserData?> getSupplier(String supplierId) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(supplierId).get();

      if (snapshot.exists) {
        return UserData(
            uid: supplierId,
            username: snapshot['company name'],
            email: snapshot['email'],
            description: snapshot['description'],
            address: snapshot['address'],
            logo: snapshot['logoLink']);
      } else {
        return null;
      }
    } catch (e) {
      print('Error when fetching user: $e');
      return null;
    }
  }

  Future<List<DocumentSnapshot>> getServiceTypesDocs(
      String categoryName) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('categories')
        .doc(categoryName)
        .collection('serviceTypes')
        .get();
    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> getCategoriesDocs() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('categories').get();
    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> getResultServices(String serviceType) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('services')
        .where('type', isEqualTo: serviceType)
        .get();

    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> getResultServicesBySupplier() async {
    auth.User currentUser = _auth.currentUser!;
    QuerySnapshot querySnapshot = await _firestore
        .collection('services')
        .where('seller id', isEqualTo: currentUser.uid)
        .get();

    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> getResultServicesBySupplierId(
      String supplierId) async {
    auth.User currentUser = _auth.currentUser!;
    QuerySnapshot querySnapshot = await _firestore
        .collection('services')
        .where('seller id', isEqualTo: supplierId)
        .get();

    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> getResultServicesExcludingCurrentService(
      String serviceType, String currentServiceId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('services')
        .where('type', isEqualTo: serviceType)
        .where(FieldPath.documentId, isNotEqualTo: currentServiceId)
        .get();

    return querySnapshot.docs;
  }

  Future<String> addReview(
      String serviceId, String reviewText, int rating) async {
    auth.User currentUser = _auth.currentUser!;
    DocumentSnapshot userSnapshot =
        await _services.users.doc(currentUser.uid).get();
    String? userName = userSnapshot['company name'] ?? userSnapshot['username'];
    String? userLogo = userSnapshot['logoLink'] ?? null;

    String reviewId = FirebaseFirestore.instance.collection('reviews').doc().id;

    QuerySnapshot reviewSnapshot = await FirebaseFirestore.instance
        .collection('reviews')
        .where('service Id', isEqualTo: serviceId)
        .where('user Id', isEqualTo: currentUser.uid)
        .get();

    if (reviewSnapshot.docs.isEmpty) {
      await FirebaseFirestore.instance.collection('reviews').add({
        'review Id': reviewId,
        'service Id': serviceId,
        'user Id': currentUser.uid,
        'user name': userName,
        'user logo': userLogo,
        'review text': reviewText,
        'rating': rating,
        'date': Timestamp.now(),
      });

      return 'success';
    } else {
      // String existingReviewText = reviewSnapshot.docs.first['review text'];
      // int existingRating = reviewSnapshot.docs.first['rating'];
      String existingDocId = reviewSnapshot.docs.first.id;

      // setState((){
      //   rating = existingRating;
      //   reviewText = existingReviewText;
      // });
      await FirebaseFirestore.instance
          .collection('reviews')
          .doc(existingDocId)
          .update({
        'review text': reviewText,
        'rating': rating,
        'user name': userName,
        'user logo': userLogo,
        'date': Timestamp.now()
      });

      return 'exists';
    }
  }

  Future<List<DocumentSnapshot>> getReviewsByServices(String serviceId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('reviews')
        .where('service Id', isEqualTo: serviceId)
        .get();
    return querySnapshot.docs;
  }

  Future<int> getReviewsBySellers(String userId) async {
    try {
      // auth.User currentUser = _auth.currentUser!;
      QuerySnapshot serviceSnapshot = await _firestore
          .collection('services')
          .where('seller id', isEqualTo: userId)
          .get();

      List<String> serviceIds =
          serviceSnapshot.docs.map((doc) => doc.id).toList();
      int totalReviews = 0;

      for (String serviceId in serviceIds) {
        QuerySnapshot reviewSnapshot = await _firestore
            .collection('reviews')
            .where('service Id', isEqualTo: serviceId)
            .get();
        totalReviews += reviewSnapshot.docs.length;
      }

      return totalReviews;
    } catch (err) {
      print('Error getting total reviews by supplier: $err');
      return 0;
    }
  }

  Future<void> toggleLike(String serviceId) async {
    try {
      auth.User currentUser = _auth.currentUser!;
      DocumentSnapshot serviceSnapshot =
          await _firestore.collection('services').doc(serviceId).get();

      if (serviceSnapshot.exists) {
        List<String> likes = List<String>.from(serviceSnapshot['likes']);

        if (likes.contains(currentUser.uid)) {
          likes.remove(currentUser.uid);
        } else {
          likes.add(currentUser.uid);
        }

        await _firestore
            .collection('services')
            .doc(serviceId)
            .update({'likes': likes});

        await appState.checkLikeStatus(serviceId);
      }
    } catch (err) {
      print('Error toggling like/dislike: $err');
    }
  }
}

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

  