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
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white, foregroundColor: Colors.black)),
      home: const RandomWords(),
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
  final _saved = <WordPair>[];

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          final tiles = _saved.map((pair) {
            return ListTile(
              title: Text(
                pair.asPascalCase,
                style: _biggerFonts,
              ),
            );
          });
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(
              children: divided,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('startup Name Generator'),
          actions: [
            IconButton(
              onPressed: _pushSaved,
              icon: const Icon(Icons.list),
              tooltip: 'Saved Suggestions',
            ),
          ],
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          // パディング
          //四方をそれぞれ指定するときはEdgeInsets.only(top: 16.0, right: 16.0, bottom: 16.0, left: 16.0)

          itemBuilder: (context, i) {
            //リストが奇数行だったら
            //if (i.isOdd) return const Divider(); //仕切り線のウィジェット
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

            final alreadySaved = _saved.contains(_suggestions[index]);

            return ListTile(
              title: Text(
                _suggestions[index].asPascalCase,
                style: _biggerFonts,
              ),
              leading: const Icon(Icons.people),
              subtitle: const Text('This is subtitle.'),
              trailing: Icon(
                alreadySaved ? Icons.favorite : Icons.favorite_border,
                color: alreadySaved ? Colors.red : null,
                semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
              ),
              onTap: () {
                setState(() {
                  if (alreadySaved) {
                    _saved.remove(_suggestions[index]);
                  } else {
                    _saved.add(_suggestions[index]);
                  }
                });
              },
            );
            //return Text(_suggestions[index].asPascalCase);
          },
        )

        //ランダムな文字列を設定したテキストを返す
        //final wordPair = WordPair.random();
        //return Text(wordPair.asPascalCase);
        );
  }
}
