import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

// punto de partida de la app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

//define el estado de la app, se puede notificar, el estado se puede compartir con ChangeNotifierProvider 
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();// notifica a todo el qeu este mirando
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) { // build se llama automaticamente cada qeu cambia algo
    var appState = context.watch<MyAppState>(); // mediante el metodo wathc se mira el estado de la app
    var pair = appState.current;

    return Scaffold(// cada build debe mostrar por lo menos un widget
      body: Column(
        children: [
          Text('Una idea random:'),
          BigCard(pair: pair),
          ElevatedButton(
            onPressed: () {
              appState.getNext();
            },
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    return Text(pair.asLowerCase);
  }
}