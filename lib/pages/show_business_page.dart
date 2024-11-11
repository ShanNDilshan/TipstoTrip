import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prototype/components/MyBusinessContainerRounded.dart';
import 'package:prototype/pages/BusinessPage/BusinessView.dart';
import 'package:prototype/pages/EventInfoPage.dart';
import 'package:prototype/pages/notificationPage.dart';

class ShowBusinessPage extends StatefulWidget {
  const ShowBusinessPage({super.key});

  @override
  State<ShowBusinessPage> createState() => _ShowBusinessPageState();
}

class _ShowBusinessPageState extends State<ShowBusinessPage> {
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
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      foregroundImage: NetworkImage(
                        FirebaseAuth.instance.currentUser!.photoURL.toString(),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateTime.now().hour > 12
                              ? "Good Evening!"
                              : "Good Morning",
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          FirebaseAuth.instance.currentUser!.displayName
                              .toString(),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 160,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('business')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Text("Loading"),
                      );
                    } else if (snapshot.hasData) {
                      var docs = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              onSelect(docs[index]['ID']);
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
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    docs[index]['business_category'],
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
                        scrollDirection: Axis.horizontal,
                      );
                    } else {
                      return const Center(
                        child: Text("Loading"),
                      );
                    }
                  }),
            ),
            Column(
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('events')
                      .where("organizer", isEqualTo: SELECTEDID)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      var docs = snapshot.data!.docs;

                      if (docs.length > 0) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
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
                                          blurRadius: 5)
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

                                              // fit: BoxFit.cover,
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
                                                      .doc(
                                                        docs[index]['id'],
                                                      )
                                                      .update({
                                                    'saved':
                                                        FieldValue.arrayRemove(
                                                            [uid]),
                                                  });
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      showCloseIcon: true,
                                                      duration:
                                                          Duration(seconds: 1),
                                                      content: Text(
                                                          'Successfully Removed '),
                                                    ),
                                                  );
                                                } else {
                                                  FirebaseFirestore.instance
                                                      .collection('events')
                                                      .doc(
                                                        docs[index]['id'],
                                                      )
                                                      .update({
                                                    'saved':
                                                        FieldValue.arrayUnion(
                                                            [uid]),
                                                  });
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      showCloseIcon: true,
                                                      duration:
                                                          Duration(seconds: 1),
                                                      content: Text(
                                                          'Successfully Added '),
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
                                                    color: const Color.fromARGB(
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
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                Text(
                                                  docs[index]['name'],
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                const Row(
                                                  children: [
                                                    Icon(
                                                      Icons.place,
                                                      color: Colors.grey,
                                                    ),
                                                    // Text(
                                                    //   docs[index]['location'],
                                                    //   style: const TextStyle(
                                                    //     fontSize: 14,
                                                    //     color: Colors.black,
                                                    //     fontWeight: FontWeight.w400,
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            docs[index]['going'].contains(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                            )
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
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
                                                const Text(
                                                  "Maximum",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.orange,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      docs[index]['max'],
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      " Participants",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.blue[900],
                                                      ),
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
                        );
                      } else {
                        return Center(
                          child: Text("No Events Found"),
                        );
                      }
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
