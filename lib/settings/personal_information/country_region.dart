import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movieapp/common/app_screen_size.dart';
import 'package:provider/provider.dart';

import '../../themes/theme_provider.dart';

class CountryRegion extends StatefulWidget {
  const CountryRegion({super.key});

  @override
  State<CountryRegion> createState() => _CountryRegionState();
}

class _CountryRegionState extends State<CountryRegion> {
  List _filteredCountries = []; // Danh sách quốc gia đã lọc
  List _countries = []; // Danh sách quốc gia gốc
  String _selectedCountry = ''; // Quốc gia đã được chọn
  @override
  void initState() {
    super.initState();
    readJson();
  }

  Future<void> readJson() async {
    try {
      // Đọc dữ liệu từ tệp JSON
      String response = await rootBundle.loadString('assets/countries.json');

      // Giải mã dữ liệu JSON
      Map<String, dynamic> data = json.decode(response);

      setState(() {
        // Lấy danh sách quốc gia từ dữ liệu JSON
        _countries = data["filteredCountries"];
        // Sao chép danh sách quốc gia gốc vào danh sách đã lọc
        _filteredCountries = List.from(_countries);
      });
    } catch (error) {
      rethrow;
    }
  }

  void _filterCountries(String query) {
    setState(() {
      _filteredCountries = _countries
          .where((country) =>
              country['name']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              country['code']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    final selectedColor = isDarkMode ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country List'),
        centerTitle: true,
      ),
      body: Padding(
        padding: AppScreenSize.uiPadding,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: selectedColor,
                  width: 1,
                ),
              ),
              child: TextField(
                onChanged: (value) => _filterCountries(value),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    fontFamily: "SF Pro Display",
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredCountries.length,
                itemBuilder: (context, index) {
                  var country = _filteredCountries[index];
                  bool isSelected = country['name'] == _selectedCountry;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            country['name'],
                            style: TextStyle(
                              fontFamily: "SF Pro Display",
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color:
                                  isSelected ? const Color(0xFFFF8311) : null,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check,
                                  color: Color(0xFFFF8311))
                              : null,
                          onTap: () {
                            setState(() {
                              // Nếu quốc gia đã được chọn, bỏ chọn nó
                              if (_selectedCountry == country['name']) {
                                _selectedCountry = '';
                              } else {
                                _selectedCountry = country['name'];
                              }
                            });
                            // Trả về quốc gia đã chọn
                            Navigator.pop(context, _selectedCountry);
                          },
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                          height: 1,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
