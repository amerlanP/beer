import 'package:flutter/material.dart';
import 'can_detail_page.dart';

class BeerCanList extends StatefulWidget {
  const BeerCanList({super.key, required this.data});
  final List<Map<String, dynamic>> data;

  @override
  State<StatefulWidget> createState() => _BeerCanListState();
}

class _BeerCanListState extends State<BeerCanList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.data.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white60,
          child: ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(widget.data[index]['CanIdentifier'].toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text('Price: \$${widget.data[index]['Price'].toString()}',
                    textAlign: TextAlign.end,
                  ),
                )

              ],
            ),
            subtitle: SizedBox(
                height: 300,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Image.network(widget.data[index]['ImageFront'].toString(),
                        errorBuilder: (context, error, trace) => Container(),
                      ),
                      Image.network(widget.data[index]['ImageLeft'].toString(),
                        errorBuilder: (context, error, trace) => Container(),
                      ),
                      Image.network(widget.data[index]['ImageRight'].toString(),
                        errorBuilder: (context, error, trace) => Container(),
                      ),
                      Image.network(widget.data[index]['ImageBack'].toString(),
                        errorBuilder: (context, error, trace) => Container(),
                      ),
                      Image.network(widget.data[index]['ImageTop'].toString(),
                        errorBuilder: (context, error, trace) => Container(),
                      ),
                    ],
                  ),
                )
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CanDetailPage(canData: widget.data[index])),
              );
            },
          ),
        );
      },
    );
  }

}