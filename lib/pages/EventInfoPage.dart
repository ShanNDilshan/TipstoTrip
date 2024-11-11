import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventInfoPage extends StatefulWidget {
  const EventInfoPage({super.key, required this.eventID});

  final String eventID;
  @override
  State<EventInfoPage> createState() => _EventInfoPageState();
}

class _EventInfoPageState extends State<EventInfoPage> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('events')
              .doc(widget.eventID)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            } else {
              var doc = snapshot.data;
              if (doc == null) return const CircularProgressIndicator();
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doc['name'],
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormat('hh:mm a')
                                    .format(doc['posted'].toDate()),
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              if (doc['going'].contains(uid)) {
                                FirebaseFirestore.instance
                                    .collection('events')
                                    .doc(
                                      widget.eventID,
                                    )
                                    .update({
                                  'going': FieldValue.arrayRemove([uid]),
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    showCloseIcon: true,
                                    duration: Duration(seconds: 1),
                                    content: Text('Successfully Removed '),
                                  ),
                                );
                              } else {
                                FirebaseFirestore.instance
                                    .collection('events')
                                    .doc(
                                      widget.eventID,
                                    )
                                    .update({
                                  'going': FieldValue.arrayUnion([uid]),
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    showCloseIcon: true,
                                    duration: Duration(seconds: 1),
                                    content: Text('Successfully Added '),
                                  ),
                                );
                              }
                            },
                            child: doc['going'].contains(uid)
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 10),
                                      child: Text("Going"),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 10),
                                      child: Text("Book Now"),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Image.network(
                        doc['image'],
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: const Color.fromRGBO(86, 105, 155, .1),
                                ),
                                child: const Icon(
                                  Icons.calendar_month,
                                  size: 45,
                                  color: Color.fromRGBO(86, 105, 255, 1),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "${doc['date']} ",
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  Text(
                                    "${doc['time']} ",
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                              // child: Column(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     const Text(
                              //       "Maximum",
                              //       textAlign: TextAlign.left,
                              //       style: TextStyle(
                              //         fontSize: 14,
                              //         color: Colors.orange,
                              //       ),
                              //     ),
                              //     Text(
                              //       "${doc['max']} Participants",
                              //       textAlign: TextAlign.left,
                              //       style: const TextStyle(
                              //         fontSize: 14,
                              //         color: Colors.black,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              ),
                          if (doc['type'] == 'event')
                            Row(
                              children: [
                                Column(
                                  children: [
                                    const Text("Maximum"),
                                    Text("${doc['max']} Participants"),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color.fromRGBO(86, 105, 155, .1),
                            ),
                            child: const Icon(
                              Icons.place,
                              size: 45,
                              color: Color.fromRGBO(86, 105, 255, 1),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          // Text(
                          //   "${doc['location']}",
                          //   textAlign: TextAlign.left,
                          //   style: const TextStyle(
                          //     fontSize: 16,
                          //     color: Colors.black,
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('business')
                              .doc(doc['organizer'])
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            } else {
                              var doc = snapshot.data;
                              return Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.blueAccent,
                                    foregroundImage: NetworkImage(
                                      doc!['image'],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        doc['business_category'],
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        "Organizer",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            }
                          }),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "About Event",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 26,
                          color: Color.fromARGB(255, 44, 44, 44),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        doc['about'],
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 59, 59, 59),
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
