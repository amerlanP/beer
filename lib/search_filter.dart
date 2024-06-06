import 'package:flutter/material.dart';
import 'databaseHelper.dart';

class SearchFilterPage extends StatefulWidget {
  @override
  _SearchFilterPageState createState() => _SearchFilterPageState();
}

class _SearchFilterPageState extends State<SearchFilterPage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();

  List<String> _types = ['Type1', 'Type2', 'Type3']; // replace with your types
  List<String> _selectedTypes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Filters'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _minPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Minimum Price',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _maxPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Maximum Price',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _stateController,
              decoration: InputDecoration(
                labelText: 'State',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _brandController,
              decoration: InputDecoration(
                labelText: 'Brand',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Column(
              children: _types.map((type) {
                return CheckboxListTile(
                  title: Text(type),
                  value: _selectedTypes.contains(type),
                  onChanged: (value) {
                    if (value!) {
                      setState(() {
                        _selectedTypes.add(type);
                      });
                    } else {
                      setState(() {
                        _selectedTypes.remove(type);
                      });
                    }
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Apply filters and navigate back to the main page
                Navigator.pop(context, {
                  'minPrice': _minPriceController.text,
                  'maxPrice': _maxPriceController.text,
                  'city': _cityController.text,
                  'state': _stateController.text,
                  'brand': _brandController.text,
                  'types': _selectedTypes,
                });
              },
              child: Text('Apply Filters'),
            ),
          ],
        ),
      ),
    );
  }
}