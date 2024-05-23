import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

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
      print("Error reading JSON file: $error");
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country List'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.black,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          child: Text(
                            country['name'],
                            style: TextStyle(
                              fontFamily: "SF Pro Display",
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color:
                                  isSelected ? const Color(0xFFFF8311) : null,
                            ),
                          ),
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
