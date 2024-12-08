import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prototype/pages/EventInfoPage.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .orderBy('posted', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var docs = snapshot.data!.docs;
                  if (docs.length == 0) {
                    return Center(child: Text('No Notifications'));
                  } else {
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        if (docs[index]['watched']
                            .contains(firebaseAuth.currentUser!.email)) {
                          return SizedBox();
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 8),
                            child: InkWell(
                              onTap: () async {
                                await FirebaseFirestore.instance
                                    .collection('notifications')
                                    .doc(docs[index]['id'])
                                    .update({
                                  'watched': FieldValue.arrayUnion(
                                    [firebaseAuth.currentUser!.email],
                                  ),
                                });
                                print(
                                    "In Progress Redirection : ${docs[index]['id']}");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EventInfoPage(
                                          eventID: docs[index]['id']),
                                    ));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                        color:
                                            Color.fromARGB(255, 226, 225, 225),
                                        spreadRadius: 5,
                                        blurRadius: 5)
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('business')
                                            .doc(docs[index]['organizer'])
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return const Text(
                                                'Something went wrong');
                                          }

                                          if (!snapshot.hasData ||
                                              !snapshot.data!.exists) {
                                            return const SizedBox();
                                          }

                                          var doc = snapshot.data!.data();
                                          if (doc == null) {
                                            return const Text(
                                                'No data available');
                                          }

                                          return Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 30,
                                                backgroundColor:
                                                    Colors.blueAccent,
                                                foregroundImage: doc['image'] !=
                                                        null
                                                    ? NetworkImage(doc['image'])
                                                    : null,
                                              ),
                                              const SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    doc['business_name'] ??
                                                        'No category',
                                                    textAlign: TextAlign.left,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    docs[index]['name'] ??
                                                        'No name',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        }),
                                    if (docs[index]['type'] == "event")
                                      Container(
                                        height: 15,
                                        width: 15,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Colors.red),
                                      ),
                                    if (docs[index]['type'] == "offer")
                                      Container(
                                        height: 15,
                                        width: 15,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Colors.green),
                                      ),
                                    if (docs[index]['type'] == "post")
                                      Container(
                                        height: 15,
                                        width: 15,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Colors.purple),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
