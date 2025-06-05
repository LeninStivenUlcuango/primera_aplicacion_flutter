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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
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

  var favoritos = <WordPair>[];

  void toggleFavorites(){
    if(favoritos.contains(current)){
      favoritos.remove(current);
    }else{
      favoritos.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) { // build se llama automaticamente cada qeu cambia algo
    var appState = context.watch<MyAppState>(); // mediante el metodo wathc se mira el estado de la app
    var pair = appState.current;
    IconData icon;
    if(appState.favoritos.contains(pair)){
      icon = Icons.favorite;
    }else{
      icon = Icons.favorite_border;
    }

    return Scaffold(// cada build debe mostrar por lo menos un widget
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // alinear al centro 
          children: [
            Text('Una idea random:'),
            SizedBox(height: 10,), // se usa para crear espacios visuales
            BigCard(pair: pair),
            SizedBox(height: 10,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(// se usa como el boton para poner un icono
                  onPressed: () {
                    appState.toggleFavorites();
                  },
                  icon: Icon(icon),
                  label: Text('Like'),
                ),
                ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
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
    final theme = Theme.of(context); //solicita el tema actual de la app
    // txtTheme se accede al tema de la fuente de la app, se podia usar bodyMedium para el texto medio esatndar
    // estilo de texto grande para la visualizacion(texto importante)
    // ! decir a dart que se lo qeu hago
    //copiWit una copia del estilo del texto
    // onPrimari es una buena opccion para usar en primary 
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary, // color sqeuma toma el color, en este hay la propiedad primary
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(pair.asLowerCase, style: style, 
        semanticsLabel: "${pair.first} ${pair.second}",), //para que las personas qeu no puedan leer
      ),
    );
  }
}