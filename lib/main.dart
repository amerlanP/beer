import 'package:flutter/material.dart';
import 'databaseHelper.dart';
import 'search_filter.dart';
import 'can_detail_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Beer Cans'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final TextEditingController _searchController = TextEditingController();
  Future<List<Map<String,dynamic>>> _canData = DatabaseHelper().getData();

  // void _searchCans(String myQuery) {
  //   try {
  //     var newData = dbHelper.getData(query: myQuery);
  //     setState(() {
  //       _canData = newData;
  //     });
  //   } catch (e) {
  //     print("ERROR $e");
  //   }
  // }
  //
  // void _searchCansWithFilters(Map<String, dynamic> filters) {
  //   try {
  //     var newData = dbHelper.getDataWithFilters(filters);
  //     setState(() {
  //       _canData = newData;
  //     });
  //   } catch (e) {
  //     print("ERROR $e");
  //   }
  // }

  //  RESPONSE A
  List<Map<String, dynamic>> _filteredData = [];

  void _searchCans(String myQuery) {
    try {
      if (_filteredData.isEmpty) {
        var newData = dbHelper.getData(query: myQuery);
        setState(() {
          _canData = newData;
        });
      } else {
        var newData = _filteredData.where((can) {
          return can['CanIdentifier'].toString().contains(myQuery);
        }).toList();
        setState(() {
          _canData = Future.value(newData);
        });
      }
    } catch (e) {
      print("ERROR $e");
    }
  }

  void _searchCansWithFilters(Map<String, dynamic> filters) {
    try {
      var newData = dbHelper.getDataWithFilters(filters);
      setState(() {
        _filteredData = [];
        _canData = newData;
        _canData.then((value) => _filteredData = value);
      });
    } catch (e) {
      print("ERROR $e");
    }
  }

  void _clearFilters() {
    setState(() {
      _filteredData = [];
      _canData = DatabaseHelper().getData();
    });
  }

  Widget _canDataBuilder(BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text('No Data Found'));
    } else {
      List<Map<String, dynamic>> data = snapshot.data!;
      return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white60,
            child: ListTile(
              title: Text(data[index]['CanIdentifier'].toString()),
              subtitle: Container(
                // decoration: BoxDecoration(
                //     border: Border.all(
                //       width: 2,
                //     )
                // ),
                // clipBehavior: Clip.hardEdge,
                  height: 300,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Image.network(data[index]['ImageFront'].toString(),
                          errorBuilder: (context, error, trace) => Container(),
                        ),
                        Image.network(data[index]['ImageLeft'].toString(),
                          errorBuilder: (context, error, trace) => Container(),
                        ),
                        Image.network(data[index]['ImageRight'].toString(),
                          errorBuilder: (context, error, trace) => Container(),
                        ),
                        Image.network(data[index]['ImageBack'].toString(),
                          errorBuilder: (context, error, trace) => Container(),
                        ),
                        Image.network(data[index]['ImageTop'].toString(),
                          errorBuilder: (context, error, trace) => Container(),
                        ),
                      ],
                    ),
                  )
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CanDetailPage(canData: data[index])),
                );
              },
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              // keyboardType: TextInputType.number,
              // textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: "Can Identifier",
                border: OutlineInputBorder()
              ),
              onChanged: _searchCans,
            ),
          ),
          // child: TextField(
          //   controller: _searchController,
          // ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>> (
        future: _canData,
        builder: _canDataBuilder,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     final filters = await Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => SearchFilterPage()),
      //     );
      //     if (filters != null) {
      //       _searchCansWithFilters(filters);
      //     }
      //   },
      //   child: Icon(Icons.filter_list),
      // ),

      //  RESPONSE A
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final filters = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchFilterPage()),
          );
          if (filters != null) {
            _searchCansWithFilters(filters);
          }
        },
        child: Icon(Icons.filter_list),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: _clearFilters,
              child: Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }
}