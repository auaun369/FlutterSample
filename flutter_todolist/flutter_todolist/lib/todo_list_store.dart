import 'package:intl/intl.dart';

class TodoListStore {
  final List<ToDoParameterModel> _list = [];

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
  void add(bool done, String content) {
    var id = count() == 0 ? 1 : _list.last.id + 1;
    var date = DateTime.now();
    var addModel = ToDoParameterModel(id, content, date, done);
    _list.add(addModel);
  }

  //Todoの更新
  void update(ToDoParameterModel model, bool done, [String? content]) {
    model.isDone = done;
    if (content != null) {
      model.content = content;
    }
  }

  //Todoの削除
  bool delete(ToDoParameterModel model) {
    return _list.remove(model);
  }
}

//ToDoリスト用のモデル
class ToDoParameterModel {
  int id;

  String content = "";

  bool isDone = false;

  DateTime? createDate;
  DateTime? updateDate;

  ToDoParameterModel(this.id, this.content, this.createDate, this.isDone);

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
}
