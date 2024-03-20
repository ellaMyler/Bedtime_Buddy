import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'UMD Messenger App'),
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
  final databaseReference = FirebaseDatabase.instance.ref();
  List<Widget> Messages = [];

  void addMessage (String sender, String message) {
    setState(() {
      final String formattedMessage = sender + ": " + message;
      Text messageWidget = Text(
        formattedMessage,
        style: TextStyle(fontSize: 25),
      );

      Messages.add(messageWidget);
    });
  }

  @override
  void initState() {
    super.initState();
    databaseReference.onChildAdded.listen((DatabaseEvent event) {
      final String sender = event.snapshot.children.first.value.toString();
      final String message = event.snapshot.children.last.value.toString();
      addMessage(sender, message);
    });
  }

  void sendMessage (String message) async {
    String name = "Enter name here";
    databaseReference.push().set({'Sender':name, 'message':message});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyText2!,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget> [
                      Expanded(
                        child: SingleChildScrollView(
                            child: Column(
                              children: Messages,
                            )),
                      ),
                      Container(
                        height: 120.0,
                        alignment: Alignment.center,
                        child: TextField(
                          onSubmitted: (String value) async {
                            sendMessage(value);
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'UMD messaging service',
                              hintText: 'Try typing a message!'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}