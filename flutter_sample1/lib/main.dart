// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  //アプリが実行されたらまずここから呼ばれる。
  //return App()　で根源のWidgetを作成
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  //StatelessWidgetはbuildメソッドを持ち、Widgetもしくはテキストを返す。
  // build メソッドでUI構築に必要なWidgetを組み合わせて組んだWidgetツリーをreturn で返す

  @override
  Widget build(BuildContext context) {
    const String title = 'Startup Name Generator';
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: const Center(
          child: RandomWords(),
        ),
      ),
    );

    //MaterialApp..デザインを簡単にしてくれるクラス
    // title... タイトル文字。(なくても動く)
    // home...画面下部のコンテンツ：アプリケーションが表示されたときに最初に表示される
    // MaterialAppはStatefulWidget
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  //スクロールするたびワードが増えるので動的なUI　Stateful Widget
  //StatefulWidgetはbuildメソッドを持たず、createstateメソッドを持ち、これがSteteクラスを返す。
  @override
  State<RandomWords> createState() => _RandomWordState();
}

class _RandomWordState extends State<RandomWords> {
  //StatefulWidgetの実態
  //Stateの役割... 状態の保持、更新、buildメソッドでWidgetツリーを返す

  final _suggestions = <WordPair>[]; // 単語のペアを保存する配列
  final _biggerFonts = const TextStyle(fontSize: 18); // フォントサイズの指定

  @override
  Widget build(BuildContext context) {
    //リストビュー
    return ListView.builder(
      padding: const EdgeInsets.all(16.0), // パディング
      //四方をそれぞれ指定するときはEdgeInsets.only(top: 16.0, right: 16.0, bottom: 16.0, left: 16.0)

      itemBuilder: (context, i) {
        //リストが奇数行だったら
        if (i.isOdd) return const Divider(); //仕切り線のウィジェット

        // 以下、偶数時の処理
        final index = i ~/ 2;
        //iは仕切り線とワードの数が一緒に数えられている変数なので
        //indexにワードの数だけを書き出す
        if (index >= _suggestions.length) {
          // suggestions... フィールドで宣言されているリスト
          //リストの最大値まで表示したらリストを10個増やす
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return ListTile(
          title: Text(_suggestions[index].asPascalCase,
                      style: _biggerFonts,
          ),
          textColor: Colors.white,
          tileColor: Colors.deepOrange,
        );
        //return Text(_suggestions[index].asPascalCase);
      },
    );

    //ランダムな文字列を設定したテキストを返す
    //final wordPair = WordPair.random();
    //return Text(wordPair.asPascalCase);
  }
}
