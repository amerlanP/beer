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
  final Map<String, String> _types = ({'Flats':'F', 'Cones':'C', 'Crowns':'K', 'Quarts':'Q', 'Pints':'P', 'Bigs':'B', 'Smalls':'S', 'Gallons':'G'});
  final List<String> _selectedTypes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Filters'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Minimum Price',
                      border: OutlineInputBorder(),
                    ),
                  )
                ),
                const SizedBox(width: 16),
                Expanded(
                    child: TextField(
                      controller: _maxPriceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Maximum Price',
                        border: OutlineInputBorder(),
                      ),
                    ),
                )
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _stateController,
              decoration: const InputDecoration(
                labelText: 'State',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _brandController,
              decoration: const InputDecoration(
                labelText: 'Brand',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: _types.entries.map((entry) {
                return CheckboxListTile(
                  title: Text(entry.key),
                  value: _selectedTypes.contains(entry.value),
                  onChanged: (value) {
                    if (value!) {
                      setState(() {
                        _selectedTypes.add(entry.value);
                      });
                    } else {
                      setState(() {
                        _selectedTypes.remove(entry.value);
                      });
                    }
                  },
                );
              }).toList()
            ),
            const SizedBox(height: 16),
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
              child: const Text('Apply Filters'),
            ),
          ],
        ),
      ),
    );
  }
}