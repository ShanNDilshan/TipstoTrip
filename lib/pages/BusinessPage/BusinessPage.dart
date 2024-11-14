import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:prototype/components/TextInputArea.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:uuid/uuid.dart';

class BusinessPage extends StatefulWidget {
  const BusinessPage(
      {super.key,
      required this.businessID,
      required this.businessName,
      required this.businessImageUrl});
  final String businessID;
  final String businessName;
  final String businessImageUrl;

  @override
  State<BusinessPage> createState() => _BusinessPageState();
}

class _BusinessPageState extends State<BusinessPage> {
  PlatformFile? pickedFile;

  final uid = FirebaseAuth.instance.currentUser!.uid;
  final mail = FirebaseAuth.instance.currentUser!.email;

  final _formKey = GlobalKey<FormState>();
  bool isloading = false;
  UploadTask? uploadTask;

  TextEditingController name = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController about = TextEditingController();
  TextEditingController max = TextEditingController();
  TextEditingController payment = TextEditingController();
  List interests = [];

  TimeOfDay? Time;

  DateTime? Date;

  @override
  Widget build(BuildContext context) {
    Future selectFiles() async {
      final result = await FilePicker.platform.pickFiles();

      if (result == null) {
        return;
      }
      if (result.files.first.size / 1000000 > 2) {
        Alert(
          context: context,
          type: AlertType.error,
          title: "Image Alert",
          desc: "Image Size must be below 2 MB",
          buttons: [
            DialogButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();

        return;
      }
      setState(() {
        pickedFile = result.files.first;
      });
    }

    void sendOneSignalNotification(
        String postTitle, String postContent, String imageUrl) async {
      const String url = 'https://onesignal.com/api/v1/notifications';
      const String apiKey =
          'MGU3ZDY5NWUtNWUwYi00YzczLWJmMjctN2ExMzU3NjEwNzYx'; // Your OneSignal REST API Key

      var notification = {
        'app_id': '0fa6318c-088e-48f5-a688-fde428b58d9f', // OneSignal App ID
        'included_segments': ['All'], // Send to all subscribed users
        'headings': {'en': postTitle},
        'contents': {'en': postContent},
        'big_picture': imageUrl, // Image URL for the notification
        'large_icon': imageUrl,
      };

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Basic $apiKey'
        },
        body: jsonEncode(notification),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Failed to send notification: ${response.body}');
      }
    }

    onSubmit() async {
      var uuid = const Uuid();

      var EventID = uuid.v4();

      print(EventID);

      var urlDownload;
      final isValid = _formKey.currentState!.validate();

      if (isValid) {
        setState(() {
          isloading = true;
        });
        final path = 'events/${EventID}/${pickedFile!.name}';
        final file = File(pickedFile!.path!);
        var imageLink;
        try {
          final ref = FirebaseStorage.instance.ref().child(path);
          uploadTask = ref.putFile(file);
          final snapshot = await uploadTask!.whenComplete(() {});
          urlDownload = await snapshot.ref.getDownloadURL();
        } catch (e) {
          Alert(
            context: context,
            type: AlertType.error,
            title: "Error",
            desc: "Error uploading. Please try again!",
            buttons: [
              DialogButton(
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                width: 120,
              )
            ],
          ).show();
          setState(() {
            isloading = false;
          });
        }

        Map<String, dynamic> userData = {
          'name': name.text,
          'location': location.text,
          'image': urlDownload,
          'date': DateFormat('E, MMM dd').format(Date!),
          'id': EventID,
          'time': DateFormat('h.mm a').format(Date!),
          'saved': [],
          'going': [],
          'organizer': widget.businessID,
          'about': about.text,
          'max': max.text,
          'type': "event",
          'posted': DateTime.now(),
          'businessName': widget.businessName,
          'businessImage': widget.businessImageUrl,
        };
        Map<String, dynamic> notificationData = {
          'name': name.text,
          'id': EventID,
          'watched': [],
          'type': "event",
          'organizer': widget.businessID,
          'posted': DateTime.now()
        };
        try {
          await FirebaseFirestore.instance
              .collection("events")
              .doc(EventID)
              .set(userData);
          await FirebaseFirestore.instance
              .collection("notifications")
              .doc(EventID)
              .set(notificationData);
          sendOneSignalNotification(
            name.text,
            about.text,
            urlDownload,
          );
          setState(() {
            isloading = false;
          });
          Navigator.pop(context);
          // Navigator.pop(context);
        } catch (e) {
          Alert(
            context: context,
            type: AlertType.error,
            title: "error",
            desc: "${e}",
            buttons: [
              DialogButton(
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                width: 120,
              )
            ],
          ).show();
          setState(() {
            isloading = false;
          });
        }
      }
    }

    email.text = mail.toString();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/images/logo.png',
          height: 50,
        ),
        centerTitle: true,
      ),
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      TextInputArea(
                        label: "Event Name",
                        typeOfTextAreaToValidate: "text",
                        TextEditingController: name,
                        isPassword: false,
                        icon: const Icon(null),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () async {
                          Date = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 2),
                          );
                          setState(() {
                            Date;
                          });
                        },
                        child: Container(
                          height: 60,
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Row(
                            children: [
                              Text(
                                Date == null
                                    ? "Pick Date"
                                    : DateFormat('E, MMM dd').format(Date!),
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () async {
                          Time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          setState(() {
                            DateTime now = DateTime.now();
                            if (Date == null) {
                              Date = DateTime(now.year, now.month, now.day,
                                  Time!.hour, Time!.minute);
                            } else {
                              Date = DateTime(Date!.year, Date!.month,
                                  Date!.day, Time!.hour, Time!.minute);
                              Time;
                            }
                          });
                        },
                        child: Container(
                          height: 60,
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Row(
                            children: [
                              Text(
                                Time == null
                                    ? "Event Time"
                                    : DateFormat('hh:mm a').format(Date!),
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextInputArea(
                        label: "Maximum Participant ",
                        type: TextInputType.number,
                        TextEditingController: max,
                        isPassword: false,
                        icon: const Icon(null),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextInputArea(
                        label: "Event Location (use Google Map) ",
                        TextEditingController: location,
                        isPassword: false,
                        icon: const Icon(null),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          selectFiles();
                        },
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: pickedFile == null
                              ? const Center(
                                  child: Text(
                                    "Upload Event Picture",
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    fit: BoxFit.cover,
                                    File(pickedFile!.path!),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextInputArea(
                        label: "About Event.....",
                        maxLines: 4,
                        TextEditingController: about,
                        isPassword: false,
                        icon: const Icon(null),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextInputArea(
                        label: "Payment Method",
                        TextEditingController: payment,
                        isPassword: false,
                        icon: const Icon(null),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () {
                          onSubmit();
                        },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromARGB(255, 226, 225, 225),
                                  spreadRadius: 5,
                                  blurRadius: 5)
                            ],
                            color: const Color(0xFF19ABBA),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(),
                                Text(
                                  "Submit Event Post",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
