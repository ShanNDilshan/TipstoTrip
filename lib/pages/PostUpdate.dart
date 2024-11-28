// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:prototype/components/ButtonOne.dart';
import 'package:prototype/components/TextInputArea.dart';

class UpdateEventPage extends StatefulWidget {
  final String iD;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> doc;
  final int ind;
  const UpdateEventPage(
      {super.key, required this.iD, required this.doc, required this.ind});

  @override
  State<UpdateEventPage> createState() => _UpdateEventPageState();
}

class _UpdateEventPageState extends State<UpdateEventPage> {
  final _formKey = GlobalKey<FormState>();
  bool isloading = false;
  PlatformFile? pickedFile;
  String? selectedEventId;
  List<Map<String, dynamic>> eventsList = [];

  TextEditingController updateEventName = TextEditingController();
  TextEditingController updateEventDate = TextEditingController();
  TextEditingController updateEventTime = TextEditingController();
  TextEditingController updateEventLocation = TextEditingController();
  TextEditingController updateAboutEvent = TextEditingController();
  TextEditingController updatePaymentMethod = TextEditingController();
  UploadTask? uploadTask;

  @override
  void initState() {
    super.initState();
    print('Initializing UpdateEventPage');
    print('Business ID: ${widget.iD}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchEvents();
    });
  }

  Future<bool> isImageUrlValid(String imageUrl) async {
    try {
      final response = await http.head(Uri.parse(imageUrl));
      return response.statusCode == 200;
    } catch (e) {
      print('Error checking image URL: $e');
      return false;
    }
  }

  Future<void> fetchEvents() async {
    try {
      print('Starting fetchEvents...');
      print('Business ID: ${widget.iD}');

      QuerySnapshot<Map<String, dynamic>> eventsSnapshot =
          await FirebaseFirestore.instance
              .collection('events')
              .where('organizer', isEqualTo: widget.iD)
              .get();

      print('Events found: ${eventsSnapshot.docs.length}');

      if (mounted) {
        setState(() {
          eventsList = eventsSnapshot.docs.map((doc) {
            print('Processing event: ${doc.data()['name']}');
            return {
              'id': doc.id,
              'name': doc.data()['name'] ?? 'Unnamed Event',
            };
          }).toList();
        });
      }

      print('Final eventsList: $eventsList');
    } catch (e) {
      print('Error in fetchEvents: $e');
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to load events: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> loadEventDetails(String eventId) async {
    try {
      print('Loading details for event ID: $eventId');
      DocumentSnapshot<Map<String, dynamic>> eventDoc = await FirebaseFirestore
          .instance
          .collection('events')
          .doc(eventId)
          .get();

      if (eventDoc.exists) {
        final data = eventDoc.data()!;

        // Verify image URL if it exists
        String? imageUrl = data['image'];
        if (imageUrl != null) {
          bool isValid = await isImageUrlValid(imageUrl);
          if (!isValid) {
            // If image URL is invalid, remove it from the document
            await FirebaseFirestore.instance
                .collection('events')
                .doc(eventId)
                .update({'image': null});
            imageUrl = null;
          }
        }

        if (mounted) {
          setState(() {
            updateEventName.text = data['name'] ?? '';
            updateEventDate.text = data['date'] ?? '';
            updateEventTime.text = data['time'] ?? '';
            updateEventLocation.text = data['location'] ?? '';
            updateAboutEvent.text = data['about'] ?? '';
            updatePaymentMethod.text = data['paymentMethod'] ?? '';
          });
        }
        print('Event details loaded successfully');
      } else {
        print('Event document does not exist');
      }
    } catch (e) {
      print('Error loading event details: $e');
    }
  }

  Future<void> updateEvent() async {
    if (_formKey.currentState!.validate()) {
      if (selectedEventId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select an event to update')),
        );
        return;
      }

      setState(() => isloading = true);

      try {
        Map<String, dynamic> updateData = {};

        if (updateEventName.text.isNotEmpty)
          updateData['name'] = updateEventName.text;
        if (updateEventDate.text.isNotEmpty)
          updateData['date'] = updateEventDate.text;
        if (updateEventTime.text.isNotEmpty)
          updateData['time'] = updateEventTime.text;
        if (updateEventLocation.text.isNotEmpty)
          updateData['location'] = updateEventLocation.text;
        if (updateAboutEvent.text.isNotEmpty)
          updateData['about'] = updateAboutEvent.text;
        if (updatePaymentMethod.text.isNotEmpty)
          updateData['paymentMethod'] = updatePaymentMethod.text;

        if (pickedFile != null) {
          final path = 'events/$selectedEventId/${pickedFile!.name}';
          final file = File(pickedFile!.path!);
          final ref = FirebaseStorage.instance.ref().child(path);

          uploadTask = ref.putFile(file);
          final snapshot = await uploadTask!.whenComplete(() {});
          final urlDownload = await snapshot.ref.getDownloadURL();
          updateData['image'] = urlDownload;

          final eventDoc = await FirebaseFirestore.instance
              .collection('events')
              .doc(selectedEventId)
              .get();

          if (eventDoc.exists && eventDoc.data()?['image'] != null) {
            try {
              await FirebaseStorage.instance
                  .refFromURL(eventDoc.data()!['image'])
                  .delete();
            } catch (e) {
              print('Error deleting old image: $e');
            }
          }
        }

        updateData['lastUpdated'] = FieldValue.serverTimestamp();

        await FirebaseFirestore.instance
            .collection('events')
            .doc(selectedEventId)
            .update(updateData);

        if (mounted) {
          setState(() => isloading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Event updated successfully')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          setState(() => isloading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update event: $e')),
          );
        }
      }
    }
  }

  Future<void> selectFiles() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    if (result.files.first.size / 1000000 > 2) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Image should be below 2 MB'),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        );
      }
      return;
    }

    setState(() {
      pickedFile = result.files.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
              ),
              color: const Color(0xFF15AAB7),
            ),
            // color: const Color(0xFF15AAB7),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 40.0, top: 50.0, bottom: 10),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[300],
                        child: widget.doc[widget.ind]['image'] != null
                            ? ClipOval(
                                child: Image.network(
                                  widget.doc[widget.ind]['image'],
                                  fit: BoxFit.cover,
                                  width: 60,
                                  height: 60,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.business,
                                      size: 30,
                                      color: Colors.grey[600],
                                    );
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Icon(
                                Icons.business,
                                size: 30,
                                color: Colors.grey[600],
                              ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 40.0, bottom: 10),
                          child: Text(
                            widget.doc[widget.ind]['business_category'],
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {},
              child: Text(" Post Update "),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: selectedEventId,
                      hint: Text('Select Event'),
                      items: eventsList.isEmpty
                          ? [
                              DropdownMenuItem<String>(
                                  value: null, child: Text('No events found'))
                            ]
                          : eventsList.map<DropdownMenuItem<String>>((event) {
                              return DropdownMenuItem<String>(
                                value: event['id'],
                                child: Text(event['name'] ?? 'Unnamed Event'),
                              );
                            }).toList(),
                      onChanged: eventsList.isEmpty
                          ? null
                          : (String? value) {
                              print('Selected event ID: $value');
                              setState(() {
                                selectedEventId = value;
                                if (value != null) {
                                  loadEventDetails(value);
                                }
                              });
                            },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextInputArea(
                      label: "Update Name ",
                      TextEditingController: updateEventName,
                      icon: const Icon(null),
                    ),
                    SizedBox(height: 15),
                    TextInputArea(
                      label: "Update Date ",
                      TextEditingController: updateEventDate,
                      icon: const Icon(null),
                    ),
                    SizedBox(height: 15),
                    TextInputArea(
                      label: "Update Time ",
                      TextEditingController: updateEventTime,
                      icon: const Icon(null),
                    ),
                    SizedBox(height: 15),
                    TextInputArea(
                      label: "Update Location",
                      TextEditingController: updateEventLocation,
                      icon: const Icon(null),
                    ),
                    SizedBox(height: 15),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: GestureDetector(
                        onTap: selectFiles,
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
                                    "Update Event picture",
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(
                                    File(pickedFile!.path!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 150,
                      child: TextInputArea(
                        label: "Update About ",
                        TextEditingController: updateAboutEvent,
                        icon: const Icon(null),
                        maxLines: 5,
                      ),
                    ),
                    SizedBox(height: 15),
                    TextInputArea(
                      label: "Payment Method ",
                      TextEditingController: updatePaymentMethod,
                      icon: const Icon(null),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const SizedBox(height: 35),
                    InkWell(
                      onTap: isloading ? null : updateEvent,
                      child: ButtonOne(
                        label: isloading ? "Updating..." : "Update Your Event",
                        icon: Icon(null),
                        color: Color.fromRGBO(53, 208, 219, 1),
                        textColor: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 45),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
