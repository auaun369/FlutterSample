import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'todo_list_store.dart';
import 'detail_page.dart';

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
  final TodoListStore _store = TodoListStore();

  //Method: Todo編集ページに遷移する
  void _pushTodoInputPage([ToDoParameterModel? model]) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return DetailPage(model: model);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _store.count(),
        itemBuilder: (context, index) {
          //▼Storeからアイテムの取得
          var model = _store.getItem(index);

          return Slidable(
            //▼右方向にリストアイテムをスライドしたとき
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              extentRatio: 0.25,
              children: [
                SlidableAction(
                  onPressed: (context) {
                    //▼編集画面に遷移
                    _pushTodoInputPage(model);
                  },
                  backgroundColor: Colors.yellow,
                  icon: Icons.edit,
                  label: 'Edit',
                )
              ],
            ),
            //▼左方向にリストアイテムをスライドしたとき
            endActionPane: ActionPane(
                motion: const ScrollMotion(),
                extentRatio: 0.25,
                children: [
                  SlidableAction(
                      onPressed: (context) {
                        //▼アイテムを削除する
                        setState(() => {_store.delete(model)});
                      },
                      backgroundColor: Colors.red,
                      icon: Icons.delete,
                      label: 'Delete')
                ]),
            child: Column(
              children: <Widget>[
                _OpenContainerWrapper(
                  model: model,
                  transitionType: _transitionType,
                  closedBuilder: (context, action) {
                    return Container(
                      margin: const EdgeInsets.all(10.0),
                      child: ListTile(
                        title: Text(model.content),
                        leading: Checkbox(
                          value: false,
                          //▼チェックボックスの状態変更時
                          onChanged: (value) {
                            if (value == true) {
                              setState(() {
                                _store.delete(model);
                              });
                            }
                          },
                        ),
                        subtitle: Text(model.createDate.toString()),
                        selectedColor: Colors.orange,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: OpenContainer(
        transitionType: _transitionType,
        closedElevation: 6,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(_fabDimension / 2),
          ),
        ),
        closedColor: Colors.orange,
        closedBuilder: (context, openContainer) {
          return const SizedBox(
            height: _fabDimension,
            width: _fabDimension,
            child: Center(
              child: Icon(
                Icons.add,
                color: Colors.blue,
              ),
            ),
          );
        },
        openBuilder: (context, action) => const DetailPage(),
      ),
    );
  }
}

const double _fabDimension = 56;

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
      openBuilder: (context, openContainer) => DetailPage(
        model: model,
      ),
      tappable: true,
      closedBuilder: closedBuilder,
    );
  }
}
