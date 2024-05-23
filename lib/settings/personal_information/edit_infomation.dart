import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movieapp/common/app_images.dart';

import 'package:provider/provider.dart';

import '../../provider/sign_in_provider.dart';
import '../../utils/button_action.dart';
import '../../utils/personal_information_input.dart';
import '../edit_input_country_region.dart';
import 'country_region.dart';

class EditInformationn extends StatefulWidget {
  const EditInformationn({super.key});

  @override
  State<EditInformationn> createState() => _EditInformationnState();
}

class _EditInformationnState extends State<EditInformationn> {
  String? selectedGender;
  List<String> genderOptions = ['Male', 'Female', 'Other'];
  DateTime? selectedDate;
  String? _selectedCountry; // Khai báo biến _selectedCountry ở đây
  File? selectedImage;

  Future getData() async {
    final sp = context.read<SignInProvider>();
    sp.getDataFromSharedPreferences();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile == null) return;
    setState(() {
      selectedImage = File(pickedFile.path);
    });
    Navigator.of(context).pop();
  }

  void optionPickImage(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.grey,
      context: context,
      builder: (builder) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 4.5,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    _pickImage(ImageSource.camera);
                  },
                  child: const Column(
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 50,
                      ),
                      Text('Camera'),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                  },
                  child: const Column(
                    children: [
                      Icon(
                        Icons.image,
                        size: 50,
                      ),
                      Text('Gallery'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.read<SignInProvider>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Edit information',
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 103),
                child: Stack(children: [
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFFFF8311), width: 2)),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage("${sp.imageUrl}"),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        optionPickImage(context);
                      },
                      child: Image.asset(AppImage.icEdit),
                    ),
                  )
                ]),
              ),
              const SizedBox(
                height: 20,
              ),
              PersonalInformationInput(
                titleText: 'Name',
                hintText: "${sp.name}",
                enabled: true,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(
                height: 12,
              ),
              PersonalInformationInput(
                titleText: 'Email',
                hintText: "${sp.email}",
                enabled: false,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                'Gender',
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Color(0xFF909090),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 48,
                child: DropdownButtonFormField2<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    // Add Horizontal padding using menuItemStyleData.padding so it matches
                    // the menu padding when button's width is not specified.
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    // Add more decoration..
                  ),
                  hint: const Text(
                    'Select Your Gender',
                    style: TextStyle(fontSize: 14),
                  ),
                  items: genderOptions
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    //Do something when selected item is changed.
                  },
                  onSaved: (value) {
                    selectedGender = value.toString();
                  },
                  buttonStyleData: const ButtonStyleData(
                    height: 48,
                    padding: EdgeInsets.only(right: 8),
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      IconlyLight.arrow_down_2,
                    ),
                    iconSize: 24,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                'Date of birth',
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Color(0xFF909090),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null && pickedDate != selectedDate) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                child: SizedBox(
                  height: 48,
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: TextEditingController(
                        text: selectedDate != null
                            ? "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}"
                            : "",
                      ),
                      decoration: InputDecoration(
                        hintText: "Select date",
                        hintStyle: const TextStyle(
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Color(0xFF303C41)),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Color(0xFFECEEED)),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF9F9F9),
                        suffixIcon: const Icon(
                          IconlyLight.calendar,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              GestureDetector(
                onTap: () async {
                  // Mở trang CountryRegion và nhận dữ liệu trả về
                  final selectedCountry = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CountryRegion()));

                  // Cập nhật giá trị cho phần Country/Region
                  if (selectedCountry != null) {
                    setState(() {
                      _selectedCountry = selectedCountry;
                    });
                  }
                },
                child: EditInputCountryRegion(
                  titleText: 'Country/Region',
                  hintText: _selectedCountry ?? "Select Country",
                  enabled: false,
                  keyboardType: TextInputType.text,
                  suffixIcon: Image.asset(AppImage.icMore),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              ActionButton(
                onPressed: () {},
                text: 'Save',
                backgroundColor: const Color(0xFFFF8311),
              ),
              const SizedBox(
                height: 124,
              )
            ],
          ),
        ),
      ),
    );
  }
}
