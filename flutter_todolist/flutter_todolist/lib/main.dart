import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_todolist/completed_task_page.dart';
import 'package:flutter_todolist/theme_data.dart';
import 'todo_list_store.dart';
import 'detail_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyTheme(),
      child: Consumer<MyTheme>(
        builder: (context, value, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: value.current,
            home: const MyHomePage(title: 'ToDoList'),
          );
        },
      ),
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
  final ContainerTransitionType _transitionType =
      ContainerTransitionType.fadeThrough;
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

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Future(
      () async {
        setState(() {
          _store.load();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView.builder(
        itemCount: _store.todoTaskCount(),
        itemBuilder: (context, index) {
          //▼Storeからアイテムの取得
          var model = _store.getTodoTaskItem(index);

          return Slidable(
            //▼左方向にリストアイテムをスライドしたとき
            endActionPane: ActionPane(
                motion: const ScrollMotion(),
                extentRatio: 0.5,
                children: [
                  SlidableAction(
                      onPressed: (context) {
                        //▼アイテムを削除する
                        setState(() => {_store.delete(model)});
                      },
                      backgroundColor: Colors.red,
                      icon: Icons.delete,
                      label: 'Delete'),
                  SlidableAction(
                    onPressed: (context) {
                      //▼編集画面に遷移
                      _pushTodoInputPage(model);
                    },
                    backgroundColor: Colors.yellow,
                    icon: Icons.edit,
                    label: 'Edit',
                  )
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
                        title: Text(
                          model.content,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        leading: Checkbox(
                          value: model.isDone,
                          //▼チェックボックスの状態変更時
                          onChanged: (value) {
                            setState(() {
                              //モデルの更新
                              _store.update(model, value!);
                            });
                          },
                        ),
                        subtitle: Text(model.getFormatCreateDateTime()),
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
          closedElevation: 10,
          closedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(_fabDimension / 2),
            ),
          ),
          closedColor: Theme.of(context).colorScheme.primary,
          closedBuilder: (context, openContainer) {
            return SizedBox(
              height: _fabDimension,
              width: _fabDimension,
              child: Center(
                child: Icon(
                  Icons.add_task,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            );
          },
          openBuilder: (context, action) => const DetailPage(),
          onClosed: (data) {
            setState(() {
              print('onclose');
            });
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _CustomBottomAppBar(
        fabLocation: FloatingActionButtonLocation.centerDocked,
        shape: const CircularNotchedRectangle(),
        completedTaskReturnFunc: () => setState(() {}),
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
      closedElevation: 2,
      closedColor: Theme.of(context).colorScheme.background,
      transitionType: transitionType,
      openBuilder: (context, openContainer) => DetailPage(
        model: model,
      ),
      tappable: false,
      closedBuilder: closedBuilder,
    );
  }
}

class _CustomBottomAppBar extends StatelessWidget {
  const _CustomBottomAppBar({
    required this.fabLocation,
    this.shape,
    this.completedTaskReturnFunc,
  });

  final Function? completedTaskReturnFunc;
  final FloatingActionButtonLocation fabLocation;
  final NotchedShape? shape;

  static final centerLocations = <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];

  void showSettingModalBottomSheet(BuildContext buildContext) {
    showModalBottomSheet<void>(
      context: buildContext,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 120,
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "アプリケーションテーマ選択",
                    style: Theme.of(context).textTheme.caption,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ToggleButtons(
                    borderRadius: BorderRadius.circular(2),
                    selectedBorderColor: Theme.of(context).colorScheme.primary,
                    onPressed: (index) {
                      setState(() {
                        setState(() {
                          Provider.of<MyTheme>(context, listen: false)
                              .toggele(index == 1);
                          Navigator.pop(context);
                        });
                      });
                    },
                    isSelected: <bool>[
                      !MyTheme()._isDark,
                      MyTheme()._isDark,
                    ],
                    children: const [
                      Text(
                        "ライトテーマ",
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Text(
                          "ダークテーマ",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).colorScheme.primary,
      shape: shape,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
        child: Row(
          children: [
            if (centerLocations.contains(fabLocation)) const Spacer(),
            OpenContainer(
              transitionType: ContainerTransitionType.fade,
              closedElevation: 0,
              closedBuilder: (context, action) {
                return SizedBox(
                  height: _fabDimension,
                  width: _fabDimension,
                  child: Center(
                    child: Icon(
                      Icons.done_outline,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                );
              },
              closedColor: Theme.of(context).colorScheme.primary,
              openBuilder: (context, action) {
                return const CompletedTaskListPage(
                  title: "完了済みタスク",
                );
              },
              onClosed: (data) {
                completedTaskReturnFunc?.call();
              },
            ),
            IconButton(
              tooltip: 'settings',
              icon: const Icon(Icons.settings),
              onPressed: () {
                showSettingModalBottomSheet(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MyTheme extends ChangeNotifier {
  ThemeData current = customLightTheme;
  bool _isDark = false;

  static final MyTheme _instance = MyTheme.internal();

  MyTheme.internal();

  factory MyTheme() {
    return _instance;
  }

  toggele(bool isDark) {
    _isDark = isDark;
    current = _isDark ? customDarkTheme : customLightTheme;
    notifyListeners();
  }
}
