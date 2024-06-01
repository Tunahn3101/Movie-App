import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movieapp/common/app_images.dart';

import 'package:provider/provider.dart';

import '../../provider/sign_in_provider.dart';
import '../../utils/button_action.dart';
import 'country_region.dart';

class EditInformation extends StatefulWidget {
  const EditInformation({super.key});

  @override
  State<EditInformation> createState() => _EditInformationState();
}

class _EditInformationState extends State<EditInformation> {
  String? selectedGender;
  List<String> genderOptions = ['Male', 'Female', 'Other'];
  DateTime? selectedDate;
  String? _selectedCountry;
  File? selectedImage;
  TextEditingController namecontroller = TextEditingController();

  Future getData() async {
    final sp = context.read<SignInProvider>();
    sp.getDataFromSharedPreferences();
  }

  @override
  void initState() {
    super.initState();
    getData();
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

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile == null) return;

    File imageFile = File(pickedFile.path);

    setState(() {
      selectedImage = imageFile;
    });

    Navigator.of(context).pop();
  }

  Future<void> _saveInformation() async {
    // Hiển thị dialog loading
    showLoadingDialog(context, "Saving...");

    final sp = context.read<SignInProvider>();
    String? imageUrl;

    if (selectedImage != null) {
      final imageName = '${DateTime.now().microsecondsSinceEpoch}.png';
      Reference storageReference =
          FirebaseStorage.instance.ref().child('users/$imageName');
      UploadTask uploadTask = storageReference.putFile(selectedImage!);

      await uploadTask.whenComplete(() async {
        imageUrl = await storageReference.getDownloadURL();
      });
    }

    await sp.updateUserData(
      name: namecontroller.text.isNotEmpty ? namecontroller.text : sp.name!,
      gender: selectedGender ?? sp.gender ?? '',
      dateOfBirth: selectedDate != null
          ? "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}"
          : sp.dateOfBirth ?? '',
      country: _selectedCountry ?? sp.countries ?? '',
      imageUrl: imageUrl,
    );

    Navigator.of(context).pop(); // Đóng dialog loading sau khi lưu thông tin

    if (!sp.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Information updated successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating information: ${sp.errorCode}')),
      );
    }
  }

  void showLoadingDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Người dùng không thể tắt dialog bằng cách nhấn ngoài
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 10),
              Text(text),
            ],
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
              Center(
                child: Stack(
                  children: [
                    Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFFFF8311), width: 2)),
                        child: selectedImage != null
                            ? CircleAvatar(
                                backgroundImage: FileImage(selectedImage!))
                            : CircleAvatar(
                                backgroundImage: NetworkImage("${sp.imageUrl}"),
                              )),
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
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Name',
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: namecontroller,
                keyboardType: TextInputType.name,
                enabled: true,
                decoration: InputDecoration(
                  hintText: '${sp.name}',
                  hintStyle: const TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Color(0xFF303C41)),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFECEEED)),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF9F9F9),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Email',
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  hintText: '${sp.email}',
                  hintStyle: const TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Color(0xFF303C41)),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFECEEED)),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF9F9F9),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Gender',
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
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
                  hint: Text(
                    '${sp.gender}' ?? 'Select Your Gender',
                    style: const TextStyle(fontSize: 14),
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
                    selectedGender = value.toString();
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
              const SizedBox(height: 12),
              const Text(
                'Date of birth',
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime(1990),
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
                  // absorbPointer ngắn sự kiện chạm
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: TextEditingController(
                        text: selectedDate != null
                            ? "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}"
                            : "",
                      ),
                      decoration: InputDecoration(
                        hintText: '${sp.dateOfBirth}' ?? "Select date",
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
              const SizedBox(height: 12),
              GestureDetector(
                  onTap: () async {
                    final selectedCountry = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CountryRegion(),
                      ),
                    );
                    // Cập nhật giá trị cho phần Country/Region
                    if (selectedCountry != null) {
                      setState(() {
                        _selectedCountry = selectedCountry;
                      });
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Country/Region',
                        style: TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                              hintText: _selectedCountry ?? "Select Country",
                              hintStyle: const TextStyle(
                                  fontFamily: 'SF Pro Display',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Color(0xFF303C41)),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Color(0xFFECEEED)),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF9F9F9),
                              suffixIcon: Image.asset(AppImage.icMore))),
                    ],
                  )),
              const SizedBox(
                height: 24,
              ),
              ActionButton(
                onPressed: _saveInformation,
                text: 'Save',
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
