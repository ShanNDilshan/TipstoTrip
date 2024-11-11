import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:prototype/components/TextInputArea.dart';
import 'package:prototype/components/button_colored.dart';
import 'package:prototype/pages/authentication/AuthBase.dart';

class SignUpPageTwo extends StatefulWidget {
  const SignUpPageTwo({super.key});

  @override
  State<SignUpPageTwo> createState() => _SignUpPageTwoState();
}

class _SignUpPageTwoState extends State<SignUpPageTwo> {
  PlatformFile? pickedFile;

  final uid = FirebaseAuth.instance.currentUser!.uid;
  final mail = FirebaseAuth.instance.currentUser!.email;
  final _formKey = GlobalKey<FormState>();
  bool isloading = false;
  UploadTask? uploadTask;

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController NIC = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController Contact = TextEditingController();
  TextEditingController about = TextEditingController();

  List interests = [];
  final List interestsFixed = [
    "surfing",
    "Hiking",
    "DJ party",
    "Sea Foods",
    "Solo Traveling",
    "Yoga",
    "Solo Traveling",
    "surfing",
    "Hiking",
    "DJ party",
    "Sea Foods",
  ];

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
              title: Text('Error'),
              content: Text('Image should be below 2 MB'),
              actions: <Widget>[
                TextButton(
                  child: Text('Ok'),
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

    void onSubmit() async {
      print("uploading...");
      var urlDownload;
      final isValid = _formKey.currentState!.validate();
      if (isValid) {
        setState(() {
          isloading = true;
        });
        final path = 'dp/${email.text}/${pickedFile!.name}';
        final file = File(pickedFile!.path!);
        try {
          final ref = FirebaseStorage.instance.ref().child(path);
          uploadTask = ref.putFile(file);
          final snapshot = await uploadTask!.whenComplete(() {});
          urlDownload = await snapshot.ref.getDownloadURL();
        } catch (e) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('Cant upload your image, please try again'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            },
          );
        }
        Map<String, dynamic> userData = {
          'firstName': firstName.text,
          'lastName': lastName.text,
          'NIC': NIC.text,
          'email': email.text,
          'contact': Contact.text,
          'about': about.text,
          'interests': interests,
          'image': urlDownload,
          'followers': [],
          'following': [],
        };

        final user = FirebaseAuth.instance.currentUser;

        try {
          FirebaseFirestore.instance
              .collection("users")
              .doc(userData['email'])
              .set(userData);

          await user?.updateDisplayName(firstName.text + " " + lastName.text);
          await user?.updatePhotoURL(urlDownload);
          setState(() {
            isloading = false;
          });
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AuthBase(),
              ));
        } catch (e) {
          print(e);
        }
      }
    }

    email.text = mail.toString();

    return Scaffold(
      appBar: AppBar(
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
                        label: "First Name",
                        typeOfTextAreaToValidate: "text",
                        TextEditingController: firstName,
                        isPassword: false,
                        icon: const Icon(null),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextInputArea(
                        label: "Last Name",
                        typeOfTextAreaToValidate: "text",
                        TextEditingController: lastName,
                        isPassword: false,
                        icon: const Icon(null),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextInputArea(
                        typeOfTextAreaToValidate: "text",
                        label: "NIC or Passport No",
                        TextEditingController: NIC,
                        isPassword: false,
                        icon: const Icon(null),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextInputArea(
                        typeOfTextAreaToValidate: "text",
                        label: "E Mail",
                        TextEditingController: email,
                        isForOnlyRead: true,
                        isPassword: false,
                        icon: const Icon(null),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextInputArea(
                        label: "Contact No",
                        TextEditingController: Contact,
                        isPassword: false,
                        icon: const Icon(null),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextInputArea(
                        label: "About User.....",
                        maxLines: 4,
                        TextEditingController: about,
                        isPassword: false,
                        icon: const Icon(null),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Interest',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 20),
                              ),
                              Wrap(
                                children: [
                                  for (var title in interestsFixed)
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (interests.contains(title)) {
                                              interests.remove(title);
                                            } else {
                                              interests.add(title);
                                            }
                                            print(interests);
                                          });
                                        },
                                        child: button_colored(
                                          text: title,
                                          isSelected: interests.contains(title),
                                        )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () {
                          selectFiles();
                        },
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: pickedFile == null
                              ? const Center(
                                  child: Text(
                                    "Upload User profile picture",
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.file(
                                    fit: BoxFit.cover,
                                    File(pickedFile!.path!),
                                  ),
                                ),
                        ),
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
                                  "Save as a user",
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
