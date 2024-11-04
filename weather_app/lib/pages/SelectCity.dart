import 'package:flutter/material.dart';
import 'package:weather_app/pages/home_pages.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;

class SelectCityName extends StatefulWidget {
  const SelectCityName({super.key});

  @override
  State<SelectCityName> createState() => _SelectCityNameState();
}

class _SelectCityNameState extends State<SelectCityName> {
  List<dynamic> iller = [];

  @override
  void initState() {
    super.initState();
    loadJsonData().then((data) {
      setState(() {
        iller = data;
      });
    });
  }

  Future<List<dynamic>> loadJsonData() async {
    final jsonString =
        await rootBundle.rootBundle.loadString('assets/json/Sehirler.json');
    final data = json.decode(jsonString);
    return data;
  }

  TextEditingController _cityNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select City'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text('Enter City Name'),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _cityNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'City Name',
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      HomePage(cityName: _cityNameController.text)));
            },
            child: const Text('Submit'),
          ),
          const SizedBox(height: 20),
          Expanded(child: ListViewBuild()),
        ],
      ),
    );
  }

  Widget ListViewBuild() {
    return ListView.builder(
      itemCount: iller.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(iller[index]['il']),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomePage(cityName: iller[index]['il'])));
          },
        );
      },
    );
  }
}
