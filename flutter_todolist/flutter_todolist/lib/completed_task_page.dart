import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_todolist/todo_list_store.dart';

class CompletedTaskListPage extends StatefulWidget {
  const CompletedTaskListPage({Key? key, required this.title})
      : super(key: key);

  final String title;

  @override
  State<CompletedTaskListPage> createState() => _CompletedTaskListPageState();
}

class _CompletedTaskListPageState extends State<CompletedTaskListPage> {
  @override
  void initState() {
    super.initState();
  }

  final TodoListStore _store = TodoListStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView.builder(
        itemCount: _store.completedTaskCount(),
        itemBuilder: (context, index) {
          var model = _store.getCompletedTaskItem(index);
          return Slidable(
            //▼左方向にリストアイテムをスライドしたとき
            endActionPane: ActionPane(
                motion: const ScrollMotion(),
                extentRatio: 0.5,
                children: [
                  SlidableAction(
                      onPressed: (context) {
                        //▼アイテムを未完了にする
                        setState(() => {_store.update(model, false)});
                      },
                      backgroundColor: Colors.greenAccent,
                      icon: Icons.replay_rounded,
                      label: '未完了に戻す'),
                ]),
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text(
                      model.content,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(model.getFormatCreateDateTime()),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
