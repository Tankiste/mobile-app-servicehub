// import 'dart:io';
// import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
// import 'package:firebase_auth/firebase_auth.dart' as auth;
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:servicehub/firebase_services.dart';
import 'package:servicehub/model/app_state.dart';
// import 'package:servicehub/model/auth/user_data.dart';
import 'package:servicehub/model/services/services.dart';

class OrderData {
  String id;
  String clientId;
  String serviceId;
  String sellerId;
  int price;
  Timestamp? orderDate = Timestamp.now();
  String deliverDate;
  int? completion = 0;
  bool? terminated = false;
  String? serviceName;
  String? serviceImageUrl;
  String? sellerName;
  String? sellerImageUrl;
  String? clientName;
  String? clientImageUrl;
  int? cardnumber;
  String? firstname;
  String? lastname;
  String? date;
  int? cvv;

  OrderData(
      {required this.id,
      required this.clientId,
      required this.serviceId,
      required this.sellerId,
      required this.price,
      this.orderDate,
      required this.deliverDate,
      this.completion,
      this.terminated,
      this.serviceName,
      this.serviceImageUrl,
      this.sellerName,
      this.sellerImageUrl,
      this.clientName,
      this.clientImageUrl,
      this.cardnumber,
      this.firstname,
      this.lastname,
      this.date,
      this.cvv});

  Map<String, dynamic> toMapOrder() {
    return {
      'order id': id,
      'client id': clientId,
      'service id': serviceId,
      'seller id': sellerId,
      'price': price,
      'order date': orderDate,
      'deliver date': deliverDate,
      'completion': completion,
      'terminated': terminated,
      'service name': serviceName,
      'service poster': serviceImageUrl,
      'seller name': sellerName,
      'seller image': sellerImageUrl,
      'client name': clientName,
      'client image': clientImageUrl,
    };
  }
}

class ManageOrders {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseServices _services = FirebaseServices();
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  ApplicationState appState = ApplicationState();
  Services serviceData = Services();

  Future<String> createOrder({
    required String serviceId,
    required String deliverDate,
  }) async {
    String resp = 'Some Error occured';
    auth.User currentUser = _auth.currentUser!;
    DocumentSnapshot snapshot =
        await _firestore.collection('services').doc(serviceId).get();
    DocumentSnapshot sellerSnapshot =
        await _firestore.collection('users').doc(snapshot['seller id']).get();
    DocumentSnapshot clientSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();
    try {
      if (serviceId.isNotEmpty && deliverDate.isNotEmpty) {
        DocumentReference orderRef = _firestore.collection('orders').doc();
        String orderId = orderRef.id;

        OrderData orderData = OrderData(
            id: orderId,
            clientId: currentUser.uid,
            serviceId: serviceId,
            sellerId: snapshot['seller id'],
            price: snapshot['price'],
            deliverDate: deliverDate,
            serviceName: snapshot['title'],
            serviceImageUrl: snapshot['poster'],
            sellerName: sellerSnapshot['company name'],
            sellerImageUrl: sellerSnapshot['logoLink'],
            clientName:
                clientSnapshot['username'] ?? clientSnapshot['company name'],
            clientImageUrl: clientSnapshot['logoLink']);

        orderData.orderDate = Timestamp.now();
        orderData.completion = 0;
        orderData.terminated = false;

        await orderRef.set(orderData.toMapOrder());

        resp = 'success';
      }
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }

  Future<List<DocumentSnapshot>> getClientOrders() async {
    auth.User currentUser = _auth.currentUser!;
    QuerySnapshot querySnapshot = await _firestore
        .collection('orders')
        .where('client id', isEqualTo: currentUser.uid)
        .get();

    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> getSupplierOrders() async {
    auth.User currentUser = _auth.currentUser!;
    QuerySnapshot querySnapshot = await _firestore
        .collection('orders')
        .where('seller id', isEqualTo: currentUser.uid)
        .get();

    return querySnapshot.docs;
  }

  Future<String> updateCompletion(String orderId, int completion) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('orders').doc(orderId).get();
    String resp = "Some error occured";
    try {
      if (documentSnapshot.exists) {
        await _firestore
            .collection('orders')
            .doc(orderId)
            .update({'completion': completion});
        resp = "success";
      }
    } catch (e) {
      print('Error updating the completion value: $e');
      resp = e.toString();
    }
    return resp;
  }
}
