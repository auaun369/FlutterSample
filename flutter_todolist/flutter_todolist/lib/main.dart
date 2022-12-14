import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: const MyHomePage(title: 'ToDoList'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//const double _fabDimension = 56;

class _MyHomePageState extends State<MyHomePage> {
  final snackBar = const SnackBar(
    content: Text('追加されました'),
  );

  int listCount = 0; //ListViewのカウント
  final ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _todoList.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: <Widget>[
                _OpenContainerWrapper(
                  model: _todoList[index],
                  transitionType: _transitionType,
                  closedBuilder: (context, action) {
                    return Container(
                      margin: const EdgeInsets.all(10.0),
                      child: ListTile(
                        title: Text(_todoList[index].content),
                        leading: Checkbox(
                          value: false,
                          onChanged: (value) {
                            if (value == true) {
                              setState(() {
                                _todoList.remove(_todoList[index]);
                              });
                            }
                          },
                        ),
                        subtitle: Text(_todoList[index].date.toString()),
                      ),
                    );
                  },
                )
              ],
            ),
          );
        },
      ),
     
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          setState(() {
            _todoList.add(ToDoParameterModel("A", DateTime.now()));
          });
        },
      ),
      // floatingActionButton: OpenContainer(
      //   transitionType: _transitionType,
      //   closedElevation: 6,
      //   closedShape: const RoundedRectangleBorder(
      //     borderRadius: BorderRadius.all(
      //       Radius.circular(_fabDimension / 2),
      //     ),
      //   ),
      //   closedColor: Colors.orange,
      //   closedBuilder: (context, openContainer) {
      //     return const SizedBox(
      //       height: _fabDimension,
      //       width: _fabDimension,
      //       child: Center(
      //         child: Icon(
      //           Icons.add,
      //           color: Colors.blue,
      //         ),
      //       ),
      //     );
      //   },
      //   openBuilder: (context, action) => const _AddPage(),
      // ),
    );
  }

  final List<ToDoParameterModel> _todoList = [];
}

class _DetailPage extends StatelessWidget {
  ToDoParameterModel _model = ToDoParameterModel("", null);

  _DetailPage({required ToDoParameterModel model}) {
    _model = model;
  }

  @override
  Widget build(BuildContext context) {
    Widget contentSection = Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(child: Text("内容")),
                Expanded(
                  child: Text(_model.content),
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(child: Text("日時")),
                Expanded(
                  child: Text(_model.date.toString()),
                ),
              ],
            )
          ],
        ));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Info",
        ),
      ),
      body: ListView(
        children: [
          contentSection,
        ],
      ),
    );
  }
}

class _OpenContainerWrapper extends StatelessWidget {
  const _OpenContainerWrapper(
      {required this.model,
      required this.closedBuilder,
      required this.transitionType});

  final ToDoParameterModel model;
  final CloseContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      transitionType: transitionType,
      openBuilder: (context, openContainer) => _DetailPage(
        model: model,
      ),
      tappable: true,
      closedBuilder: closedBuilder,
    );
  }
}

//ToDoリスト用のモデル
class ToDoParameterModel {
  String content = "";
  DateTime? date;

  ToDoParameterModel(this.content, this.date);
}

//class _AddPage extends StatelessWidget {
//   const _AddPage();

//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;

//     return WillPopScope(
//       onWillPop: () {
//         // var param = ToDoParameterModel();
//         // param.content = "AAA";
//         // param.date = DateTime.now();
//         // Navigator.of(context).pop(param);
//         return Future.value(true);
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             "ToDoListAdd",
//           ),
//         ),
//         body: ListView(
//           children: [
//             Container(
//               color: Colors.red,
//               child: Padding(
//                 padding: const EdgeInsets.all(70),
//                 child: Image.asset('images/splash.png', fit: BoxFit.fill),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "sample",
//                     style: textTheme.headline5!.copyWith(
//                       color: Colors.black54,
//                       fontSize: 30,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     "ohayou",
//                     style: textTheme.bodyText2!.copyWith(
//                       color: Colors.black54,
//                       height: 1.5,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }