import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoListStore {
  List<ToDoParameterModel> _list = [];

  //ストア　インスタンス
  static final TodoListStore _instance = TodoListStore.internal();

  //プライベートコンストラクタ
  TodoListStore.internal();

  //ファクトリーコンストラクタ(シングルトン)
  factory TodoListStore() {
    return _instance;
  }

  int count() {
    return _list.length;
  }

  ToDoParameterModel getItem(int index) {
    return _list[index];
  }

  //Todoの追加
  ToDoParameterModel add(bool done, String content, String memo) {
    var id = count() == 0 ? 1 : _list.last.id + 1;
    var date = DateTime.now();
    var addModel = ToDoParameterModel(id, content, memo, date, done, date);
    _list.add(addModel);
    save();
    return addModel;
  }

  //Todoの更新
  void update(ToDoParameterModel model, bool done,
      [String? content, String? memo]) {
    model.isDone = done;
    if (content != null) {
      model.content = content;
    }
    if (memo != null) {
      model.memo = memo;
    }
    save();
  }

  //Todoの削除
  bool delete(ToDoParameterModel model) {
    var removed = _list.remove(model);
    save();
    return removed;
  }

  void save() async {
    var prefs = await SharedPreferences.getInstance();
    var saveTargetList = _list.map((e) => json.encode(e.toJson())).toList();
    prefs.setStringList(_saveKey, saveTargetList);
  }

  void load() async {
    var prefs = await SharedPreferences.getInstance();
    var loadTargetList = prefs.getStringList(_saveKey) ?? [];
    _list = loadTargetList
        .map((e) => ToDoParameterModel.fromJson(json.decode(e)))
        .toList();
  }

  final String _saveKey = "TodoList";
}

//ToDoリスト用のモデル
class ToDoParameterModel {
  late int id;

  late String content = "";

  late String memo = "";

  late bool isDone = false;

  late DateTime? createDate;
  late DateTime? updateDate;

  ToDoParameterModel(this.id, this.content, this.memo, this.createDate,
      this.isDone, this.updateDate);

  //作成日時のフォーマット文字列取得
  String getFormatCreateDateTime() {
    return _getFormatDateTime(createDate);
  }

  //更新日時のフォーマット文字列取得
  String getFormatUpdateDateTime() {
    return _getFormatDateTime(updateDate);
  }

  String _getFormatDateTime(DateTime? datetime) {
    if (datetime == null) {
      return "";
    }

    var format = DateFormat("yyyy/MM/dd HH:mm");
    var dateTime = format.format(datetime);
    return dateTime;
  }

  //Json形式に変換
  Map toJson() {
    return {
      'id': id,
      'content': content,
      'memo': memo,
      'isDone': isDone,
      'createDate': createDate.toString(),
      'updateDate': updateDate.toString(),
    };
  }

  //Mapをモデルに変換
  ToDoParameterModel.fromJson(Map json) {
    id = json['id'];
    content = json['content'];
    memo = json['memo'];
    isDone = json['isDone'];
    createDate = DateTime.tryParse(json['createDate']);
    updateDate = DateTime.tryParse(json['updateDate']);
  }
}
