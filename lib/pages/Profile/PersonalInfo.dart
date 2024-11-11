import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:prototype/components/ButtonOne.dart';
import 'package:prototype/components/TextInputArea.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  String groupValue = "male";
  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.value = const TextEditingValue(text: "user4567@gmail.com");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal Information"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const TextInputArea(
              label: "Give name",
              type: TextInputType.text,
              typeOfTextAreaToValidate: "text",
              isPassword: false,
              icon: Icon(null),
            ),
            const SizedBox(
              height: 20,
            ),
            const TextInputArea(
              typeOfTextAreaToValidate: "text",
              label: "Surname",
              isPassword: false,
              icon: Icon(null),
            ),
            const SizedBox(
              height: 20,
            ),
            const TextInputArea(
              label: "Date Of Birth",
              typeOfTextAreaToValidate: "text",
              isPassword: false,
              icon: Icon(null),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: const Text("Male"),
                    value: 'male',
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() {
                        groupValue = value.toString();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text("Female"),
                    value: 'Female',
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() {
                        groupValue = value.toString();
                      });
                    },
                  ),
                ),
              ],
            ),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                  enabled: false,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  labelText: "Email ",
                  suffixIcon: Icon(Icons.check)),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        "Country/Region",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      ),
                      CountryCodePicker(),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                const Expanded(
                    child: TextInputArea(
                  typeOfTextAreaToValidate: "number",
                  type: TextInputType.number,
                  label: "Mobile Number",
                  isPassword: false,
                  icon: Icon(null),
                ))
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const ButtonOne(
              label: "Save",
              icon: Icon(null),
              color: Color.fromRGBO(53, 208, 219, 1),
              textColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
