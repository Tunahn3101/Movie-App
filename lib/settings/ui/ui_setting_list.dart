import 'package:flutter/material.dart';
import 'package:movieapp/common/app_images.dart';
import 'package:movieapp/extension/extension_core.dart';
import 'package:movieapp/settings/action_model.dart';
import 'package:movieapp/settings/ui/ui_section_container.dart';

class UISettingList extends StatelessWidget {
  const UISettingList({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      [
        ActionModel(
          title: 'Personal information',
          icon: AppImage.icProfile,
          ontap: () {},
          isMore: true,
        ),
        ActionModel(
          title: 'Change Password',
          icon: AppImage.icPassWord,
          ontap: () {},
          isMore: true,
        ),
        ActionModel(
          title: 'Dark Mode',
          icon: AppImage.icDarkMode,
          ontap: () {},
          darkMode: true,
        )
      ],
      [
        ActionModel(
          title: 'Share app',
          icon: AppImage.iscShare,
          ontap: () {},
        ),
        ActionModel(
          title: 'App reviews',
          icon: AppImage.icRate,
          ontap: () {},
        ),
        ActionModel(
          title: 'Help',
          icon: AppImage.icHelp,
          ontap: () {},
        )
      ],
      [
        ActionModel(
          title: 'About us',
          icon: AppImage.icAboutUs,
          ontap: () {},
          isMore: true,
        ),
        ActionModel(
          title: 'Privacy Policy',
          icon: AppImage.icPrivacyPolicy,
          ontap: () {},
          isMore: true,
        ),
        ActionModel(
          title: 'Terms of Service',
          icon: AppImage.icTermsOfService,
          ontap: () {},
          isMore: true,
        ),
      ]
    ];

    return Column(
      children: data.mapIndexed((element, index) {
        if (index == 0) {
          return UISectionContainer(data: element);
        } else {
          return Column(
            children: [
              const SizedBox(height: 16),
              UISectionContainer(data: element)
            ],
          );
        }
      }).toList(),
    );
  }
}
