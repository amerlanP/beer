import 'package:flutter/material.dart';
import 'databaseHelper.dart';
import 'search_filter.dart';
import 'can_detail_page.dart';
import 'presentation.dart';

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
      title: 'Beer Can App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
  bool _filters = false;

  Future<void> _searchCans(String myQuery) async {
    try {
      if (!_filters) {  // Search can identifier only
        var newData = dbHelper.getData(query: myQuery);
        setState(() {
          _canData = newData;
        });
      } else {  // Search can identifier in filtered search results
        var newData = (await _canData).where((can) {
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
        _filters = true;
        _canData = newData;
      });
    } catch (e) {
      print("ERROR $e");
    }
  }

  void _clearFilters() {
    setState(() {
      _filters = false;
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
      return BeerCanList(data: data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 3,
        shadowColor: Colors.black,
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: "Can Identifier",
            border: OutlineInputBorder()
          ),
          onChanged: _searchCans,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(16),
          child: Container()
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>> (
        future: _canData,
        builder: _canDataBuilder,
      ),

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
        child: const Icon(Icons.filter_list),
      ),
      bottomNavigationBar: _filters ? BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: _clearFilters,
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      ) : null,
    );
  }
}