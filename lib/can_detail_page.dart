import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';


class CanDetailPage extends StatefulWidget {
  final Map<String, dynamic> canData;
  const CanDetailPage({super.key, required this.canData});

  @override
  State<CanDetailPage> createState() => _CanDetailPageState();
}

class _CanDetailPageState extends State<CanDetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.canData['CanIdentifier'].toString()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: () {
              launchUrl(Uri.parse('http://bcca-usbc-supplement.com/Volume1SupplementDetailView.aspx?@CanIdentifierForDetailView=${widget.canData['CanIdentifier']}'));
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 400,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // Image.network(widget.canData['ImageFront'].toString(),
                //   errorBuilder: (context, error, trace) => Container(),
                // ),
                GestureDetector(
                  child: InteractiveViewer(
                    minScale: 1.0,
                    maxScale: 10.0,
                    child: Image.network(widget.canData['ImageFront'].toString(),
                      errorBuilder: (context, error, trace) => Container(),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return InteractiveViewer(
                          minScale: 1.0,
                          maxScale: 10.0,
                          child: Image.network(widget.canData['ImageFront'].toString(),
                            errorBuilder: (context, error, trace) => Container(),
                          ),
                        );
                      }
                      )
                    );
                  },
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text("Field")),
                DataColumn(label: Text("Value")),
              ],
              rows: widget.canData.entries.map((entry) {
                return DataRow(cells: [
                  DataCell(Text(entry.key)),
                  DataCell(
                    Text(entry.value.toString()),
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: entry.value.toString()));
                    }
                  ),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}