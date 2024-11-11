import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:prototype/components/ButtonOne.dart';
import 'package:prototype/components/TextInputArea.dart';
import 'package:uuid/uuid.dart';

class BusinessForm extends StatefulWidget {
  const BusinessForm({super.key});

  @override
  State<BusinessForm> createState() => _BusinessFormState();
}

class _BusinessFormState extends State<BusinessForm> {
  final _formKey = GlobalKey<FormState>();
  bool isloading = false;
  PlatformFile? pickedFile;
  TextEditingController BCC = TextEditingController();
  TextEditingController AL1C = TextEditingController();
  TextEditingController AL2C = TextEditingController();
  TextEditingController AL3C = TextEditingController();
  TextEditingController BLC = TextEditingController();
  TextEditingController MAC = TextEditingController();
  TextEditingController BWSUC = TextEditingController();
  UploadTask? uploadTask;
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address = "";

  String? selectedBusinessCategory; // To store selected category
  final List<String> businessCategories = [
    'Transportation',
    'Accommodation',
    'Food and Beverage',
    'Entertainment',
    'Connected Industries',
    'Adventure and Sport'
  ];

  @override
  Widget build(BuildContext context) {
    Future selectFiles() async {
      final result = await FilePicker.platform.pickFiles();
      if (result == null) {
        return;
      }

      if (result.files.first.size / 1000000 > 2) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Image should be below 2 MB'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        );
        return;
      }

      setState(() {
        pickedFile = result.files.first;
      });
    }

    Future Register() async {
      var uuid = const Uuid();
      final isValid = _formKey.currentState!.validate();
      if (isValid) {
        setState(() {
          isloading = true;
        });
        var urlDownload;

        final path = 'dp/business/${pickedFile!.name}';
        final file = File(pickedFile!.path!);
        var imageLink;
        try {
          final ref = FirebaseStorage.instance.ref().child(path);
          uploadTask = ref.putFile(file);
          final snapshot = await uploadTask!.whenComplete(() {});
          urlDownload = await snapshot.ref.getDownloadURL();
        } catch (e) {
          setState(() {
            isloading = false;
          });
        }

        var uid = uuid.v1();
        try {
          await FirebaseFirestore.instance.collection('business').doc(uid).set({
            'business_category': BCC.text,
            'address_line1': AL1C.text,
            'address_line2': AL2C.text,
            'address_line3': AL3C.text,
            'business_location': BLC.text,
            'mac_address': MAC.text,
            'business_website_url': BWSUC.text,
            'country': countryValue,
            'state': stateValue,
            'author': FirebaseAuth.instance.currentUser!.uid,
            'image': urlDownload,
            'ID': uid,
          });
          setState(() {
            isloading = false;
          });
          Navigator.pop(context);
        } catch (e) {
          print(e);
          setState(() {
            isloading = false;
          });
        }
      }
    }

    GlobalKey<CSCPickerState> _cscPickerKey = GlobalKey();

    return Scaffold(
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Image.asset(
                          'assets/images/logo.png',
                          height: 100,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        // TextInputArea(
                        //   label: "Business category ",
                        //   TextEditingController: BCC,
                        //   icon: const Icon(null),
                        // ),
                        //Equvilant For Business Category Textarea
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: selectedBusinessCategory,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              border: InputBorder.none,
                              hintText: 'Select Business Category',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a business category';
                              }
                              return null;
                            },
                            items: businessCategories.map((String category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedBusinessCategory = newValue;
                                BCC.text = newValue ??
                                    ''; // Update the text controller as well
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextInputArea(
                          label: "Address Line 1",
                          TextEditingController: AL1C,
                          icon: const Icon(null),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextInputArea(
                          label: "Address Line 2",
                          TextEditingController: AL2C,
                          icon: const Icon(null),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextInputArea(
                          label: "Address Line 3",
                          TextEditingController: AL3C,
                          icon: const Icon(null),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CSCPicker(
                          showCities: false,
                          onCountryChanged: (value) {
                            countryValue = value;
                          },
                          onStateChanged: (value) {
                            if (value == null) return;
                            stateValue = value;
                          },
                          onCityChanged: (value) {},
                          searchBarRadius: 100,
                          selectedItemStyle: const TextStyle(
                            fontSize: 15,
                          ),
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextInputArea(
                          label: "Business Location (use google map)",
                          TextEditingController: BLC,
                          icon: const Icon(null),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextInputArea(
                          label: "Mail Address",
                          TextEditingController: MAC,
                          icon: const Icon(null),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextInputArea(
                          label: "Business web site URL",
                          TextEditingController: BWSUC,
                          icon: const Icon(null),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: GestureDetector(
                            onTap: () {
                              selectFiles();
                            },
                            child: Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: pickedFile == null
                                  ? const Center(
                                      child: Text(
                                        "Upload Business profile picture",
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.file(
                                        fit: BoxFit.cover,
                                        File(pickedFile!.path!),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        InkWell(
                          onTap: () => Register(),
                          child: const ButtonOne(
                              label: "Save Your Business",
                              icon: Icon(null),
                              color: Color.fromRGBO(53, 208, 219, 1),
                              textColor: Colors.black),
                        ),
                        const SizedBox(
                          height: 45,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
