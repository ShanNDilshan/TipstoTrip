// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:prototype/components/ButtonOne.dart';
import 'package:prototype/components/TextInputArea.dart';
import 'package:uuid/uuid.dart';

class PostOffer extends StatefulWidget {
  final String iD;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> doc;
  final int ind;
  const PostOffer(
      {super.key, required this.iD, required this.doc, required this.ind});

  @override
  State<PostOffer> createState() => _PostOfferState();
}

class _PostOfferState extends State<PostOffer> {
  final _formKey = GlobalKey<FormState>();

  bool isloading = false;
  PlatformFile? pickedFile;

  TextEditingController offerName = TextEditingController();
  TextEditingController offerDate = TextEditingController();
  TextEditingController offerTime = TextEditingController();
  TextEditingController offerLocation = TextEditingController();
  TextEditingController aboutOffer = TextEditingController();
  TextEditingController paymentMethod = TextEditingController();
  UploadTask? uploadTask;
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

    Future<bool> addToNotify(eventId, eventName) async {
      List<String> watchedArray = [];
      try {
        await FirebaseFirestore.instance
            .collection('notifications')
            .doc(eventId)
            .set({
          'id': eventId,
          'name': eventName,
          'organizer': widget.iD,
          'posted': offerTime.text,
          'type': 'offer',
          'watched': watchedArray
        });
        return true;
      } catch (e) {
        return false;
      }
    }

    //Save data in DB

    Future AddEvent() async {
      var uuid = const Uuid();
      final isValid = _formKey.currentState!.validate();
      if (isValid) {
        setState(() {
          isloading = true;
        });

        String eventId = uuid.v1(); // Generate unique ID for the event
        String urlDownload = '';

        try {
          // Create folder structure: events/eventId/filename
          if (pickedFile != null) {
            final path = 'events/$eventId/${pickedFile!.name}';
            final file = File(pickedFile!.path!);

            final ref = FirebaseStorage.instance.ref().child(path);
            uploadTask = ref.putFile(file);
            final snapshot = await uploadTask!.whenComplete(() {});
            urlDownload = await snapshot.ref.getDownloadURL();
          }

          // Get current timestamp
          Timestamp currentTime = Timestamp.now();
          addToNotify(eventId, offerName.text);
          // Add data to Firestore
          await FirebaseFirestore.instance
              .collection('events')
              .doc(eventId)
              .set({
            'about': aboutOffer.text,
            'businessImage': widget.doc[widget.ind]
                ['image'], // Using business image from passed data
            'businessName': widget.doc[widget.ind][
                'business_category'], // Using business category from passed data
            'date': offerDate.text,
            'going': [], // Empty array for going
            'saved': [], // Empty array for saved
            'id': eventId,
            'image': urlDownload,
            'location': offerLocation.text,
            'name': offerName.text,
            'organizer': widget.iD, // Using passed ID as organizer
            'posted': currentTime,
            'time': offerTime.text,
            'type': 'offer'
          });

          setState(() {
            isloading = false;
          });
          Navigator.pop(context);
        } catch (e) {
          print('Error: $e');
          setState(() {
            isloading = false;
          });

          // Show error dialog
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Failed to create event: $e'),
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
        }
      }
    }

    return Scaffold(
      body: Column(
        children: [
          // Fixed Header
          Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
              ),
              color: const Color(0xFF15AAB7),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 40.0, top: 50.0, bottom: 10),
                    child: CircleAvatar(
                      radius: 30,
                      foregroundImage:
                          NetworkImage(widget.doc[widget.ind]['image']),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, bottom: 10),
                        child: Text(
                          widget.doc[widget.ind]['business_name'],
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
              ],
            ),
          ),

          const SizedBox(
            height: 15,
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {},
              child: Text(" Post Offer "),
            ),
          ),
          const SizedBox(height: 15),

          // Scrollable Form Section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          TextInputArea(
                            label: "Offer Name ",
                            TextEditingController: offerName,
                            icon: const Icon(null),
                          ),

                          SizedBox(
                            height: 15,
                          ),
                          TextInputArea(
                            label: "Offer Date ",
                            TextEditingController: offerDate,
                            icon: const Icon(null),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextInputArea(
                            label: "Offer Time ",
                            TextEditingController: offerTime,
                            icon: const Icon(null),
                          ),
                          SizedBox(
                            height: 15,
                          ),

                          SizedBox(
                            height: 15,
                          ),
                          TextInputArea(
                            label: "Offer Location",
                            TextEditingController: offerLocation,
                            icon: const Icon(null),
                          ),

                          const SizedBox(
                            height: 15,
                          ),
                          //Image Upload

                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: GestureDetector(
                              onTap: () {
                                selectFiles();
                              },
                              child: Container(
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: pickedFile == null
                                    ? const Center(
                                        child: Text(
                                          "Upload Event picture",
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : ClipRRect(
                                        // borderRadius: BorderRadius.circular(20),
                                        child: Image.file(
                                          fit: BoxFit.cover,
                                          File(pickedFile!.path!),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: 150,
                            child: TextInputArea(
                              label: "About Offer",
                              TextEditingController: aboutOffer,
                              icon: const Icon(null),
                              maxLines: 5,
                            ),
                          ),

                          SizedBox(
                            height: 15,
                          ),
                          TextInputArea(
                            label: "Payment Method ",
                            TextEditingController: paymentMethod,
                            icon: const Icon(null),
                          ),

                          const SizedBox(
                            height: 35,
                          ),
                          InkWell(
                            onTap: () {
                              if (!isloading) {
                                AddEvent();
                              }
                            },
                            child: isloading
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ButtonOne(
                                    label: "Submit Offer Post",
                                    icon: Icon(null),
                                    color: Color.fromRGBO(53, 208, 219, 1),
                                    textColor: Colors.black,
                                  ),
                          ),

                          const SizedBox(
                            height: 45,
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
