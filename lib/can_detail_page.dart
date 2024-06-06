import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class CanDetailPage extends StatefulWidget {
  final Map<String, dynamic> canData;

  CanDetailPage({required this.canData});

  @override
  _CanDetailPageState createState() => _CanDetailPageState();
}

class _CanDetailPageState extends State<CanDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.canData['CanIdentifier']),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.open_in_browser),
            onPressed: () {
              launch('https://www.google.com');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Image.network(widget.canData['ImageFront'].toString(),
                  errorBuilder: (context, error, trace) => Container(),
                ),
                Image.network(widget.canData['ImageLeft'].toString(),
                  errorBuilder: (context, error, trace) => Container(),
                ),
                Image.network(widget.canData['ImageRight'].toString(),
                  errorBuilder: (context, error, trace) => Container(),
                ),
                Image.network(widget.canData['ImageBack'].toString(),
                  errorBuilder: (context, error, trace) => Container(),
                ),
                Image.network(widget.canData['ImageTop'].toString(),
                  errorBuilder: (context, error, trace) => Container(),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Field')),
                  DataColumn(label: Text('Value')),
                ],
                rows: widget.canData.entries.map((entry) {
                  return DataRow(cells: [
                    DataCell(Text(entry.key)),
                    DataCell(Text(entry.value.toString())),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}