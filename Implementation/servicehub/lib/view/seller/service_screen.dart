import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:servicehub/controller/widgets.dart';

import 'package:servicehub/view/request_send.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import 'package:servicehub/view/seller/created_service_screen.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  bool _isChecked = false;
  File? image;
  final _formkey = GlobalKey<FormState>();

  String? categoryDropdown;
  String? typeDropdown;
  String? dateDropdown;
  List<String> fields = [
    'Network Administration',
    'Software Development',
    'Cybersecurity',
    'Database Management',
    'Cloud Computing',
  ];

  List<String> dates = [
    '1 day',
    '3 days',
    '5 days',
    '1 week',
    '2 weeks',
    '1 month',
    '3 months',
  ];

  String? fileName;

  Widget _catdropDownButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 80),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: DropdownButtonFormField(
          value: categoryDropdown,
          iconEnabledColor: Colors.grey.shade400,
          hint: Text(
            'Select a Category ',
            style: TextStyle(
                color: Colors.grey.shade400, fontWeight: FontWeight.w300),
          ),
          style: TextStyle(color: Colors.grey.shade300, fontSize: 15),
          items: fields.map((field) {
            return DropdownMenuItem<String>(
              value: field,
              child: Text(
                field,
                style: TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              categoryDropdown = value!;
            });
          },
          decoration: InputDecoration(
              border: UnderlineInputBorder(
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.fromLTRB(10, 3, 5, 3)),
        ),
      ),
    );
  }

  Widget _typedropDownButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 80),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: DropdownButtonFormField(
          value: typeDropdown,
          iconEnabledColor: Colors.grey.shade400,
          hint: Text('Select A Type ',
              style: TextStyle(
                  color: Colors.grey.shade400, fontWeight: FontWeight.w300)),
          style: TextStyle(color: Colors.grey.shade300, fontSize: 15),
          items: fields.map((field) {
            return DropdownMenuItem<String>(
              value: field,
              child: Text(
                field,
                style: TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              typeDropdown = value!;
            });
          },
          decoration: InputDecoration(
              border: UnderlineInputBorder(borderSide: BorderSide.none),
              contentPadding: EdgeInsets.fromLTRB(10, 3, 5, 3)),
        ),
      ),
    );
  }

  Widget _datedropDownButton() {
    return Container(
      width: 125,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButtonFormField(
        value: dateDropdown,
        iconEnabledColor: Colors.grey.shade400,
        hint: Text(
          'Choose ',
          style: TextStyle(
              color: Colors.grey.shade400, fontWeight: FontWeight.w300),
        ),
        style: TextStyle(color: Colors.grey.shade300, fontSize: 15),
        items: dates.map((field) {
          return DropdownMenuItem<String>(
            value: field,
            child: Text(
              field,
              style: TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            dateDropdown = value!;
          });
        },
        decoration: InputDecoration(
            border: UnderlineInputBorder(
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.fromLTRB(10, 3, 0, 3)),
      ),
    );
  }

  Future<bool> requestGalleryPermission() async {
    final status = await Permission.storage.status;
    debugPrint("storage permission $status");
    if (status.isDenied) {
      debugPrint("storage permission === $status");
      final granted = await Permission.storage.request();
      return granted.isGranted;
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    } else {
      return true;
    }
  }

  Future pickImage() async {
    final hasPermission = await requestGalleryPermission();
    if (!hasPermission) {
      return null;
    }
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        image = File(result.files.single.path!);
        fileName = result.files.first.name;
      });
    } else {
      print('No Image Selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
          text: 'New service',
          actionText: '',
          showFilter: false,
          returnButton: true,
          showText: false),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 15, top: 25, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Service title",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Container(
                            height: 70,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                )),
                            child: TextFormField(
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  hintText: "Name of your service",
                                  contentPadding: EdgeInsets.only(
                                      left: 10, right: 5, bottom: 5),
                                  hintStyle: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15),
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'N.B :',
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  ' Choose the most relevant keywords possible cause that’s',
                                  style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                            Text(
                              'what buyers would likely use to search for a such service.',
                              style: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 12),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text("Category",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(height: 5),
                        _catdropDownButton(),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text("Service Type",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(height: 5),
                        _typedropDownButton(),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            const Text("Price",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                            const SizedBox(
                              width: 170,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Container(
                                width: 130,
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    )),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      suffixText: '€',
                                      suffixStyle: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                      hintText: "0.00",
                                      contentPadding: EdgeInsets.only(
                                        left: 50,
                                        right: 20,
                                      ),
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 17),
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text("Description",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                )),
                            child: TextFormField(
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      left: 10, right: 5, bottom: 5),
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: Text(
                            'Briefly describe your service',
                            style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            const Text("Delivery Time",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                            const SizedBox(
                              width: 100,
                            ),
                            _datedropDownButton(),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text("Poster",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                        Text(
                          'Showcase your service with a poster or a video.',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 65),
                          child: Container(
                            width: 210,
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: InkWell(
                                onTap: () {
                                  pickImage();
                                },
                                child: image == null
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 7),
                                        child: Column(
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.image,
                                              color: Colors.grey.shade600,
                                              size: 60,
                                            ),
                                            const SizedBox(height: 15),
                                            Text('Choose a Photo or a video',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        Colors.grey.shade600)),
                                            const SizedBox(height: 3),
                                            Text('Browse',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        Colors.blue.shade800)),
                                          ],
                                        ),
                                      )
                                    : Image.file(
                                        image!,
                                        width: 210,
                                        height: 160,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 70),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            CreatedServiceScreen())));
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFC84457),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  )),
                              child: const Padding(
                                padding: EdgeInsets.only(
                                    left: 90, right: 90, top: 15, bottom: 15),
                                child: Text(
                                  'Create Service',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
