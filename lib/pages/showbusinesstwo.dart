// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prototype/components/event_list.dart';
import 'package:prototype/pages/Business_clicked.dart';
import 'package:prototype/pages/EventInfoPage.dart';

class ShowBusinesstwoPage extends StatefulWidget {
  const ShowBusinesstwoPage({super.key});

  @override
  State<ShowBusinesstwoPage> createState() => _ShowBusinesstwoPageState();
}

class _ShowBusinesstwoPageState extends State<ShowBusinesstwoPage> {
  String SELECTEDID = "";

  void onSelect(ID) {
    setState(() {
      SELECTEDID = ID;
    });
  }

  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // First Part - Top Profile Section
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                ),
                color: const Color.fromARGB(255, 255, 255, 255),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              height: 250,
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 40.0, top: 50.0, bottom: 10),
                      child: CircleAvatar(
                        radius: 30,
                        foregroundImage: NetworkImage(
                          FirebaseAuth.instance.currentUser!.photoURL
                              .toString(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 40.0, bottom: 10),
                          child: Text(
                            FirebaseAuth.instance.currentUser!.displayName
                                .toString(),
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ),
                      ],
                    ),
                  ]),
                ],
              ),
            ),
          ),

          // Second Part - Horizontal Business List
          Positioned(
            top: 180,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 160,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('business')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Text("Loading"));
                  } else if (snapshot.hasData) {
                    var docs = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: docs.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            onSelect(docs[index]['ID']);
                            String docID = docs[index]['ID'];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BusinessClickedPage(
                                  iD: docID,
                                  doc: docs,
                                  ind: index,
                                ), // Navigate to DetailsPage
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  foregroundImage:
                                      NetworkImage(docs[index]['image']),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  docs[index]['business_name'],
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text("Loading"));
                  }
                },
              ),
            ),
          ),

          // Third Part - Events List
          Positioned(
            top: 320,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('events')
                        .orderBy('posted', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData) {
                        var docs = snapshot.data!.docs;
                        return ListView.builder(
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
                                child: EventList(
                                  organizerName: docs[index]['businessName'],
                                  organizerImage: docs[index]['businessImage'],
                                  eventUploadedTime: docs[index]['posted'],
                                  eventType: docs[index]['type'],
                                  date: docs[index]['date'],
                                  time: docs[index]['time'],
                                  eventName: docs[index]['name'],
                                  isGoing: docs[index]['going'],
                                  maxParticipants:
                                      docs[index]['type'] == 'event'
                                          ? docs[index]['max']
                                          : '0',
                                  participants: docs[index]['going'].length,
                                  saved: docs[index]['saved'],
                                  id: docs[index]['id'],
                                  eventImage: docs[index]['image'],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
