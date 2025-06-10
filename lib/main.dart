import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// StatelessWidget es recomendable usar para una misma pantalla o componente ya que su estado se manejaria internamente 
// StatefulWidget es recomendado para no alamcenar muschas variables en nuestro manejador de estado, ya que tiene su propio estado
// --responsive
// hay algunas cosas qeu la hacen responsive como -wrap es como column o row qeu une automaticsmnete
// - Fittedbox incluye elemetno secundario en el espacio sobrante segun la configuracion
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

  var favorites = <WordPair>[];

  void toggleFavorite(){
    if(favorites.contains(current)){
      favorites.remove(current);
    }else{
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {// el guion bajo(_) hace que sea privado
  // aqui ponemos los estados
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // variables dentro del widget
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = ListLikes(); // un widget util que usa un rectngulo tachado indica que no esta terminado
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(// se llama cada vez que als restricciones cambian(ejm el susuario cambia el tamaño de la app)
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea( // ayuda a que los elemetos no se muestren oscurecidos
                child: NavigationRail( // tambien evita que se vean obscuresidos por una barra de estado
                  extended: constraints.maxWidth >= 600, // al cambiar a true muestra la setiqeutas junto a los titulos( se extiende )
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: selectedIndex, // indica cual parte del menu esta seleccionado
                  onDestinationSelected: (value) { //metodo qeu se usa segun la seleccion
                    // similar a notifyListeners
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded( // nos ayudan a ocupar le espacio restante
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class ListLikes extends StatelessWidget {
  const ListLikes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final favorites = appState.favorites;
    return ListView.builder(
      itemCount: appState.favorites.length,
  itemBuilder: (context, index) {
    final pair = appState.favorites[index];
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.favorite),
        title: Text(
          pair.asPascalCase,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.grey),
          onPressed: () {
            // Elimina el favorito si tienes lógica para eso
            // appState.removeFavorite(pair);
          },
        ),
      ),
    );
  },
      );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
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