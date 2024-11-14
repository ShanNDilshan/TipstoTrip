import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prototype/components/MyBusinessContainerRounded.dart';
import 'package:prototype/components/button_colored.dart';
import 'package:prototype/pages/BusinessPage/BusinessForm.dart';
import 'package:prototype/pages/BusinessPage/BusinessView.dart';
import 'package:prototype/pages/Profile/EditProfile.dart';
import 'package:prototype/pages/authentication/AuthBase.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.email!)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Text("Loading"),
                    );
                  } else if (!snapshot.hasData ||
                      !(snapshot.data?.exists ?? false)) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AuthBase()),
                        (Route<dynamic> route) => false,
                      );
                    });
                    return const Center(
                      child: Text("Loading"),
                    );
                  } else {
                    var docs = snapshot.data;

                    return Column(
                      children: [
                        Center(
                          child: CircleAvatar(
                              maxRadius: 60,
                              foregroundImage: NetworkImage(
                                docs!['image'],
                              )),
                        ),
                        Text(
                          docs['firstName'] + " " + docs['lastName'],
                          style: const TextStyle(
                            fontSize: 21,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: SizedBox(
                                child: Column(
                                  children: [
                                    Text(
                                      "${docs['following'].length}",
                                      style: const TextStyle(
                                        fontSize: 21,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "Following",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.grey.shade400,
                              height: 50,
                              width: 2,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: SizedBox(
                                child: Column(
                                  children: [
                                    Text(
                                      "${docs['followers'].length}",
                                      style: const TextStyle(
                                        fontSize: 21,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "Followers",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const EditProfile(),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.blue,
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.edit,
                                        color: Colors.purple,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Edit Profile",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                FirebaseAuth.instance.signOut();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AuthBase(),
                                    ));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.blue,
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.logout,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "LogOut",
                                        selectionColor: Colors.blue,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "My Business",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              style: const ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                Colors.blue,
                              )),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BusinessForm(),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 180,
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('business')
                                  .where('author', isEqualTo: uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
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
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Businessview(
                                                BusinessID: docs[index]['ID'],
                                              ),
                                            ),
                                          );
                                        },
                                        child: MyBusinessContainerRounded(
                                          name: docs[index]
                                              ['business_category'],
                                          imageLink: docs[index]['image'],
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
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "About Me",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          docs['about'],
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey.shade600,
                            // fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Row(
                          children: [
                            Text(
                              "Interest",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          children: [
                            for (var title in docs['interests'])
                              button_colored(isSelected: false, text: title)
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  setState(() {
                                    deleteProfile(context);
                                  });
                                },
                                child: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Image.asset(
                                        'assets/images/delete.png')),
                              ),
                              const Text("Delete Profile")
                            ],
                          ),
                        )
                      ],
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }
}

Future<void> deleteProfile(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // Prevent closing by tapping outside the dialog
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Profile'),
        content: const Text('Are you sure you want to delete this profile?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog without action
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              try {
                // Delete the profile from Firestore
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.email!)
                    .delete();

                // Sign out the user
                await FirebaseAuth.instance.signOut();

                // Navigate to the AuthBase page, clearing the back stack
                await Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthBase()),
                  (Route<dynamic> route) => false,
                );

                // Show a success message
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
