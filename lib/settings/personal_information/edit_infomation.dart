import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movieapp/common/app_images.dart';
import 'package:movieapp/themes/theme_provider.dart';

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
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
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
                                  backgroundImage:
                                      NetworkImage("${sp.imageUrl}"),
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
                TextField(
                  autofocus: false,
                  controller: namecontroller,
                  enabled: true,
                  decoration: InputDecoration(
                    hintText: '${sp.name}',
                    hintStyle: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color:
                          isDarkMode ? Colors.white : const Color(0xFF303C41),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      borderSide: BorderSide(color: Color(0xFFECEEED)),
                    ),
                    fillColor: isDarkMode
                        ? Colors.grey.shade800
                        : Colors.grey.shade200,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      borderSide: BorderSide(
                          color: isDarkMode
                              ? Colors.white38
                              : const Color(0xFF303C41)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      borderSide: BorderSide(
                        color: isDarkMode
                            ? Colors.white38
                            : const Color(0xFF303C41),
                      ),
                    ),
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
                TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    hintText: '${sp.email}',
                    hintStyle: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color:
                          isDarkMode ? Colors.white : const Color(0xFF303C41),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFFECEEED),
                      ),
                    ),
                    filled: true,
                    fillColor: isDarkMode
                        ? Colors.grey.shade800
                        : Colors.grey.shade200,
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
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        borderSide: BorderSide(
                          color: isDarkMode
                              ? Colors.white38
                              : const Color(0xFF303C41),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        borderSide: BorderSide(
                            color: isDarkMode
                                ? Colors.white38
                                : const Color(0xFF303C41)),
                      ),
                      fillColor: isDarkMode
                          ? Colors.grey.shade800
                          : Colors.grey.shade200,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      // Add more decoration..
                    ),
                    hint: Text(
                      '${sp.gender}' ?? 'Select Your Gender',
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            isDarkMode ? Colors.white : const Color(0xFF303C41),
                      ),
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
                    iconStyleData: IconStyleData(
                      icon: Icon(
                        IconlyLight.arrow_down_2,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      iconSize: 24,
                    ),
                    dropdownStyleData: const DropdownStyleData(
                      isOverButton: true,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 8,
                              spreadRadius: 8,
                            )
                          ]),
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
                      child: TextField(
                        controller: TextEditingController(
                          text: selectedDate != null
                              ? "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}"
                              : "",
                        ),
                        decoration: InputDecoration(
                          hintText: '${sp.dateOfBirth}' ?? "Select date",
                          hintStyle: TextStyle(
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF303C41),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 16,
                          ),
                          fillColor: isDarkMode
                              ? Colors.grey.shade800
                              : Colors.grey.shade200,
                          suffixIcon: Icon(
                            IconlyLight.calendar,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide: BorderSide(
                              color: isDarkMode
                                  ? Colors.white38
                                  : const Color(0xFF303C41),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide: BorderSide(
                                color: isDarkMode
                                    ? Colors.white38
                                    : const Color(0xFF303C41)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Country/Region',
                  style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
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
                  child: AbsorbPointer(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: _selectedCountry ?? "Select Country",
                        hintStyle: TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xFF303C41),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          borderSide: BorderSide(
                            color: isDarkMode
                                ? Colors.white38
                                : const Color(0xFF303C41),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          borderSide: BorderSide(
                              color: isDarkMode
                                  ? Colors.white38
                                  : const Color(0xFF303C41)),
                        ),
                        suffixIcon: Image.asset(
                          AppImage.icMore,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                ActionButton(
                  onPressed: _saveInformation,
                  text: 'Save',
                  backgroundColor: const Color(0xFFFF8311),
                ),
                const SizedBox(height: 30)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
