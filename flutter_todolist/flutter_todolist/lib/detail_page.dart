import 'todo_list_store.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final ToDoParameterModel? model;

  const DetailPage({Key? key, this.model}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final TodoListStore _store = TodoListStore();

  late bool _isCreateTodo;

  //late String _title;

  late String _content;

  late String _memo;

  late bool _done;

  // late String _createDate;

  @override
  void initState() {
    super.initState();
    var model = widget.model;
    _isCreateTodo = model == null;
    _content = model?.content ?? "";
    _memo = model?.memo ?? "";
    _done = model?.isDone ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //アプリケーションバーに表示するタイトル
        title: Text(_isCreateTodo ? 'Todo追加' : 'Todo編集'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Visibility(
              visible: !_isCreateTodo,
              child: CheckboxListTile(
                title: const Text('完了'),
                value: _done,
                onChanged: ((value) {
                  setState(() {
                    _done = value ?? false;
                  });
                }),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                  labelText: "内容",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.cyan,
                    ),
                  )),
              //▼SetStateなしでも画面更新可能になる。
              controller: TextEditingController(text: _content),
              onChanged: (value) {
                _content = value;
              },
            ),
            const SizedBox(height: 20),
            // 詳細のテキストフィールド
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 3,
              decoration: InputDecoration(
                labelText: "Memo",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.cyan,
                  ),
                ),
              ),
              // TextEditingControllerを使用することで、いちいちsetStateしなくても画面を更新してくれる
              controller: TextEditingController(text: _memo),
              onChanged: (String value) {
                _memo = value;
              },
            ),
            const SizedBox(
              height: 60,
            ),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_isCreateTodo) {
                      //▼Todoを追加する
                      _store.add(false, _content, _memo);
                    } else {
                      //▼Todoを更新する
                      _store.update(widget.model!, _done, _content, _memo);
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    _isCreateTodo ? '追加' : '更新',
                    style: const TextStyle(color: Colors.white),
                  ),
                )),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  side:
                      BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
                child: const Text(
                  "キャンセル",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
