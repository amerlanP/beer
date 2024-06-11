import 'package:flutter/material.dart';

class SearchFilterPage extends StatefulWidget {
  const SearchFilterPage({super.key});

  @override
  State<SearchFilterPage> createState() => _SearchFilterPageState();
}

class _SearchFilterPageState extends State<SearchFilterPage> {
  final Map<String, String> _types = ({'Flats':'F', 'Cones':'C', 'Crowns':'K', 'Quarts':'Q', 'Pints':'P', 'Bigs':'B', 'Smalls':'S', 'Gallons':'G'});
  final List<String> _selectedTypes = [];
  final List<String> _textFields = ['Can Identifier','Brand', 'Brewery', 'City', 'State'];
  final Map<String, TextEditingController> _textControllers = ({
    'minPrice': TextEditingController(),
    'maxPrice':TextEditingController(),
    'Can Identifier':TextEditingController(),
    'Brand':TextEditingController(),
    'Brewery':TextEditingController(),
    'City':TextEditingController(),
    'State':TextEditingController()
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Filters'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ListView.separated(
              shrinkWrap: true,
              itemCount: _textFields.length,
              itemBuilder: (context, index) => (
                  TextField(
                    controller: _textControllers[_textFields[index]],
                    decoration: InputDecoration(
                      labelText: _textFields[index],
                      border: const OutlineInputBorder(),
                    ),
                  )
              ),
              separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textControllers['minPrice'],
                    decoration: const InputDecoration(
                      labelText: 'Minimum Price',
                      border: OutlineInputBorder(),
                    ),
                  )
                ),
                const SizedBox(width: 16),
                Expanded(
                    child: TextField(
                      controller: _textControllers['maxPrice'],
                      decoration: const InputDecoration(
                        labelText: 'Maximum Price',
                        border: OutlineInputBorder(),
                      ),
                    ),
                )
              ],
            ),
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
                  'minPrice': _textControllers['minPrice']!.text.trim(),
                  'maxPrice': _textControllers['maxPrice']!.text.trim(),
                  'city': _textControllers['City']!.text.trim(),
                  'state': _textControllers['State']!.text.trim(),
                  'brand': _textControllers['Brand']!.text.trim(),
                  'brewery': _textControllers['Brewery']!.text.trim(),
                  'canIdentifier': _textControllers['Can Identifier']!.text.trim(),
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