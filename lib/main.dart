import 'package:flutter/material.dart';
import 'databaseHelper.dart';

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

  void _searchCans(String myQuery) {
    try {
      var newData = dbHelper.getData(query: myQuery);
      setState(() {
        _canData = newData;
      });
    } catch (e) {
      print("ERROR $e");
    }
    // setState(() {
    //   _canData = dbHelper.getData(myQuery);
    //   print("SEARCH QUERY: ${myQuery}");
    // });
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
              )
            )
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
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Can Identifier",
                border: OutlineInputBorder()
              ),
              onSubmitted: _searchCans,
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
    );
  }
}