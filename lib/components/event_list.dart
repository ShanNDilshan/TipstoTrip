import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventList extends StatelessWidget {
  const EventList({
    super.key,
    required this.organizerName,
    required this.organizerImage,
    required this.eventUploadedTime,
    required this.eventType,
    required this.date,
    required this.time,
    required this.eventName,
    required this.maxParticipants,
    required this.participants,
    required this.isGoing,
    required this.saved,
    required this.id,
    required this.eventImage,
  });

  final String organizerName;
  final String organizerImage;
  final Timestamp eventUploadedTime;
  final String eventType;
  final String date;
  final String time;
  final String eventName;
  final String maxParticipants;
  final int participants;
  final List isGoing;
  final List saved;
  final String eventImage;
  final String id;

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
              color: Color.fromARGB(255, 226, 225, 225),
              spreadRadius: 5,
              blurRadius: 5)
        ],
      ),
      padding:
          const EdgeInsetsDirectional.symmetric(horizontal: 5, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blueAccent,
                    foregroundImage: NetworkImage(
                      organizerImage,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        organizerName,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('hh:mm a')
                            .format(eventUploadedTime.toDate()),
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  if (saved.contains(uid)) {
                    FirebaseFirestore.instance
                        .collection('events')
                        .doc(
                          id,
                        )
                        .update({
                      'saved': FieldValue.arrayRemove([uid]),
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
                          id,
                        )
                        .update({
                      'saved': FieldValue.arrayUnion([uid]),
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
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: saved.contains(uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 30,
                        )
                      : const Icon(
                          Icons.favorite_outline,
                          color: Colors.black,
                          size: 30,
                        ),
                ),
              ),
              if (eventType == "event")
                Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.red),
                ),
              if (eventType == "offer")
                Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.green),
                ),
              if (eventType == "post")
                Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.purple),
                ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  eventImage,
                  width: MediaQuery.sizeOf(context).width / 2.5,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${date} : $time",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width / 2.1,
                      child: Text(
                        eventName,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const Row(
                      children: [
                        Icon(
                          Icons.place,
                          size: 25,
                          color: Color.fromRGBO(167, 167, 167, 1),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${isGoing.length} going",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                isGoing.contains(uid)
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 199, 199, 199),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: const Text("going"),
                      )
                    : const SizedBox(),
                // Only show maximum participants for events
                if (eventType == "event")
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Maximum",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.orange,
                          ),
                        ),
                        Text(
                          "${maxParticipants} Participants",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
