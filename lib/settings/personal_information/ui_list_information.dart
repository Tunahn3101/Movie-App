import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/sign_in_provider.dart';
import './ui_information.dart';
import 'personal_model.dart';

class UIListInformation extends StatefulWidget {
  const UIListInformation({super.key});

  @override
  State<UIListInformation> createState() => _UIListInformationState();
}

class _UIListInformationState extends State<UIListInformation> {
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
    final informationList = [
      PersonalModel(
        titleText: 'Name',
        hintText: '${sp.name}',
      ),
      PersonalModel(
        titleText: 'Email',
        hintText: '${sp.email}',
      ),
      PersonalModel(
        titleText: 'Gender',
        hintText: '${sp.gender}',
      ),
      PersonalModel(
        titleText: 'Date of birth',
        hintText: '${sp.dateOfBirth}',
      ),
      PersonalModel(
        titleText: 'Country/Region',
        hintText: '${sp.countries}',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < informationList.length; i++)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UIInformation(list: informationList[i]),
              if (i < informationList.length - 1) const SizedBox(height: 12),
            ],
          ),
      ],
    );
  }
}
