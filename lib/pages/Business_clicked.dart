// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prototype/pages/EventInfoPage.dart';
import 'package:prototype/pages/PostEventPage.dart';
import 'package:prototype/pages/PostOffer.dart';
import 'package:prototype/pages/PostUpdate.dart';
import 'package:prototype/pages/showbusinesstwo.dart';

class BusinessClickedPage extends StatefulWidget {
  final String iD;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> doc;
  final int ind;
  const BusinessClickedPage(
      {super.key, required this.iD, required this.doc, required this.ind});

  @override
  State<BusinessClickedPage> createState() => _BusinessClickedPageState();
}

class _BusinessClickedPageState extends State<BusinessClickedPage> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //Header
          Container(
            // width: double.infinity,
            height: 250,
            color: const Color(0xFF15AAB7),
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
                          widget.doc[widget.ind]['business_category'],
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 60,
                ),
                SizedBox(
                    height: 90,
                    width: 30,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          InkWell(
                              //ToDo - Add business Delete Logic
                              onTap: () async {
                                showDeleteConfirmationDialog(
                                    context, widget.iD);
                              },
                              child: Image.asset('assets/images/delete.png')),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          //Three Cards
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PostEventPage(
                                  iD: widget.iD,
                                  doc: widget.doc,
                                  ind: widget.ind)));
                    },
                    child: Text("Post Event")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PostOffer(
                                  iD: widget.iD,
                                  doc: widget.doc,
                                  ind: widget.ind)));
                    },
                    child: Text("Post Offer")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateEventPage(
                                  iD: widget.iD,
                                  doc: widget.doc,
                                  ind: widget.ind)));
                    },
                    child: Text("Post Update")),
              ],
            ),
          ),

          //Events
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('events')
                  .where("organizer", isEqualTo: widget.iD)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  var docs = snapshot.data!.docs;

                  if (docs.length > 0) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 20),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EventInfoPage(
                                          eventID: docs[index]['id'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromARGB(
                                              255, 226, 225, 225),
                                          spreadRadius: 5,
                                          blurRadius: 5,
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                docs[index]['image'],
                                                width: double.infinity,
                                                height: 350,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: InkWell(
                                                onTap: () {
                                                  if (docs[index]['saved']
                                                      .contains(uid)) {
                                                    FirebaseFirestore.instance
                                                        .collection('events')
                                                        .doc(docs[index]['id'])
                                                        .update({
                                                      'saved': FieldValue
                                                          .arrayRemove([uid]),
                                                    });
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        showCloseIcon: true,
                                                        duration: Duration(
                                                            seconds: 1),
                                                        content: Text(
                                                            'Successfully Removed'),
                                                      ),
                                                    );
                                                  } else {
                                                    FirebaseFirestore.instance
                                                        .collection('events')
                                                        .doc(docs[index]['id'])
                                                        .update({
                                                      'saved':
                                                          FieldValue.arrayUnion(
                                                              [uid]),
                                                    });
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        showCloseIcon: true,
                                                        duration: Duration(
                                                            seconds: 1),
                                                        content: Text(
                                                            'Successfully Added'),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              34, 141, 0, 0),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: docs[index]['saved']
                                                            .contains(uid)
                                                        ? const Icon(
                                                            Icons.favorite,
                                                            color: Colors.red,
                                                            size: 30,
                                                          )
                                                        : const Icon(
                                                            Icons
                                                                .favorite_outline,
                                                            color: Colors.white,
                                                            size: 30,
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    docs[index]['date'] +
                                                        ' ' +
                                                        docs[index]['time'],
                                                    style: const TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.blueAccent,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  Text(
                                                    docs[index]['name'],
                                                    style: const TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  const Row(
                                                    children: [
                                                      Icon(
                                                        Icons.place,
                                                        color: Colors.grey,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              docs[index]['going'].contains(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid)
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: Colors.grey[300],
                                                      ),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10,
                                                          vertical: 4),
                                                      child: const Text(
                                                        "Going",
                                                        style: TextStyle(
                                                            fontSize: 17),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${docs[index]['going'].length} Going",
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      // Text(
                                                      //   docs[index]['max'],
                                                      //   style: const TextStyle(
                                                      //     fontSize: 14,
                                                      //     color: Colors.black,
                                                      //     fontWeight: FontWeight.bold,
                                                      //   ),
                                                      // ),
                                                      // Text(
                                                      //   " Participants",
                                                      //   style: TextStyle(
                                                      //     fontSize: 14,
                                                      //     color: Colors.blue[900],
                                                      //   ),
                                                      // ),

                                                      if (docs[index]['type'] ==
                                                          'event')
                                                        Row(
                                                          children: [
                                                            Column(
                                                              children: [
                                                                const Text(
                                                                    "Maximum"),
                                                                Text(
                                                                    "${docs[index]['max']} Participants"),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text("No Events Found"),
                    );
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Future<String> deleteDocument(String Id) async {
//   try {
//     await FirebaseFirestore.instance.collection('business').doc(Id).delete();
//     String successDlt = "deleted";
//     return successDlt;
//   } catch (e) {
//     String failDlt = "failed";
//     return failDlt;
//   }
// }

Future<void> showDeleteConfirmationDialog(
    BuildContext context, String Id) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // Prevent closing by tapping outside the dialog
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Profile'),
        content: Text('Are you sure you want to delete this profile?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog without action
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () async {
              // Perform the delete action
              try {
                await FirebaseFirestore.instance
                    .collection('business')
                    .doc(Id)
                    .delete();
                print("Profile deleted successfully");

                // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShowBusinesstwoPage()),
                );

                // Optionally, navigate back or show a success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Profile deleted successfully")),
                );
              } catch (e) {
                print("Error deleting profile: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error deleting profile")),
                );
              }
            },
            child: Text('Yes'),
          ),
        ],
      );
    },
  );
}
