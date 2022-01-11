import 'package:flutter/material.dart';
import 'package:flutter_proj/database/database_games.dart';
import 'package:flutter_proj/database/echipe_db_repo.dart';
import 'package:flutter_proj/database/meci_db_repo.dart';
import 'package:flutter_proj/model/echipa.dart';
import 'package:flutter_proj/service/service.dart';
import 'package:flutter_proj/ui/elements/bottom_bar.dart';
import 'package:flutter_proj/ui/elements/custom_alert.dart';
import 'package:flutter_proj/ui/elements/search_bar.dart';
import 'package:flutter_proj/ui/pages/add_games_page.dart';
import 'package:provider/provider.dart';

import 'model/mecidto.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MyDatabaseImplementation.gamesDatabase.recreateDB();
  // await MyDatabaseImplementation.gamesDatabase.recreateDB();
  IEchipaDBRepo echipeRepo = EchipeRepositoryDB();
  await echipeRepo.init();
  IMeciDBRepo meciuriRepo = MeciRepositoryDB();
  await meciuriRepo.init();
  Service serv = Service(echipeRepo, meciuriRepo);

  try {
    await serv.getAllMeciuri();
    await serv.getAllEchipe();
    for (var el in await serv.getAllMeciuri2()) {
      print(el.id);
    }
  } catch (e) {
    for (var el in await serv.getAllMeciuri2()) {
      print(el.Echipa1 + " " + el.Echipa2);
    }
  }
  // serv.addEchipa(
  //     10,
  //     "Arsenal FC",
  //     "https://upload.wikimedia.org/wikipedia/en/thumb/5/53/Arsenal_FC.svg/800px-Arsenal_FC.svg.png",
  //     "Wembley",
  //     "Corsarul");
  // serv.addEchipa(
  //     15,
  //     "Manunited",
  //     "https://upload.wikimedia.org/wikipedia/en/thumb/7/7a/Manchester_United_FC_crest.svg/1200px-Manchester_United_FC_crest.svg.png",
  //     "Old Trafford",
  //     "adas");
  // serv.addEchipa(
  //     9,
  //     "Mancity",
  //     "https://vectorlogo4u.com/wp-content/uploads/2020/11/Manchester-city-logo-1024x484.png",
  //     "Qatar",
  //     "Al-Khalif");
  // serv.addEchipa(
  //     12,
  //     "Chelsea FC",
  //     "https://upload.wikimedia.org/wikipedia/ro/thumb/c/cc/Chelsea_FC.svg/1200px-Chelsea_FC.svg.png",
  //     "London Stadium",
  //     "Abramovici");
  runApp(ChangeNotifierProvider(create: (context) => serv, child: MyApp(serv)));
}

class MyApp extends StatelessWidget {
  final Service serv;
  const MyApp(this.serv, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'games',
      home: MyHomePage(serv, title: "games"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Service serv;
  List<MeciDTO> meciuri = List.empty(growable: true);
  List<Echipa> echipe = List.empty(growable: true);
  MyHomePage(this.serv, {Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool loading = true;

  @override
  void initState() {
    getItems();
    super.initState();
  }

  Future getItems() async {
    loading = true;
    widget.meciuri = await widget.serv.getAllMeciuriDTO();
    widget.echipe = await widget.serv.getAllEchipe2();
    setState(() {
      loading = false;
    });
  }

  Widget getList() {
    getItems();
    return Scaffold(
        body: ListView.builder(
      itemCount: widget.meciuri.length,
      itemBuilder: (context, index) {
        return getItem(widget.meciuri[index]);
      },
    ));
  }

  void handleUpdate(MeciDTO meci) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddMeciPage(
                widget.serv,
                "AddGAME",
                meci.Echipa1,
                meci.Echipa2,
                meci.goluri1.toString(),
                meci.goluri2.toString(),
                true)));
  }

  void handleDelete(int id) {
    widget.serv.deleteMeci(id);
    Navigator.pop(context);
  }

  void handleMeciClick(MeciDTO meci) {
    show2ButtonAlertDialog(context, () => {handleDelete(meci.id)}, () {
      handleUpdate(meci);
    });
  }

  Widget getItem(MeciDTO meci) {
    return InkWell(
      child: Card(
        color: Colors.white,
        shadowColor: const Color(0XFF66302d),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Column(children: [
                Image(
                  image: NetworkImage(meci.echipa1img),
                  width: 50,
                  height: 100,
                ),
                Text(meci.Echipa1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20)),
                Text(meci.goluri1.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20)),
              ]),
            ),
            Expanded(
              flex: 2,
              child: Column(children: const [
                Text(" ",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                Text(" ",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                Text("-",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ]),
            ),
            Expanded(
              flex: 4,
              child: Column(children: [
                Image(
                  image: NetworkImage(meci.echipa2img),
                  width: 50,
                  height: 100,
                ),
                Text(meci.Echipa2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20)),
                Text(meci.goluri2.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20))
              ]),
            )
          ],
        ),
      ),
      onTap: () => {handleMeciClick(meci)},
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const CircularProgressIndicator();
    }
    return Scaffold(
      body: Center(
          child:
              Consumer<Service>(builder: (context, serv, child) => getList())),
      bottomNavigationBar: bottomBar(widget.serv, ""),
      appBar: searchBar("", context, widget.serv, widget.echipe),
    );
  }
}
