import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../provider/sign_in_provider.dart';
import '../../utils/button_action.dart';
import '../../utils/next_screen.dart';
import 'edit_infomation.dart';
import 'ui_list_information.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  Future getData() async {
    final sp = context.read<SignInProvider>();
    sp.getDataFromSharedPreferences();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<SignInProvider>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Personal information',
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: const Color(0xFFFF8311), width: 2),
                    ),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        "${sp.imageUrl}",
                      ),
                    )),
              ),
              const SizedBox(height: 20),
              const UIListInformation(),
              const SizedBox(height: 24),
              ActionButton(
                onPressed: () {
                  nextScreen(context, const EditInformation());
                },
                text: 'Edit',
                backgroundColor: const Color(0xFFFF8311),
              ),
              const SizedBox(height: 90)
            ],
          ),
        ),
      ),
    );
  }
}
