import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutterapp/src/saved.dart';
import 'Bloc/Bloc.dart';

class RandomList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RandomListState();
  }
}

class _RandomListState extends State<RandomList> {
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _saved = Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("naming app"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              //클릭이 됬을 때
              Navigator.of(context).push(//페이지 이동 가능
                  MaterialPageRoute(builder: (context) => SavedList()));
            },
          )
        ],
      ),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return StreamBuilder<Set<WordPair>>(
        stream: bloc.savedStream,
        builder: (context, snapshot) {
          return ListView.builder(itemBuilder: (context, index) {
            //0 , 2 , 4 가 real times ,1, 3, 5 는  Divider
            if (index.isOdd) {
              //index가 홀수면
              return Divider(); //선하나 긋기
            }

            var realIndex = index ~/ 2; //index를 2로 나눈 몫을 realIndex에 저장

            if (realIndex >= _suggestions.length) {
              //아이템들의 갯수보다 많거나 같으면
              _suggestions
                  .addAll(generateWordPairs().take(10)); //랜덤 단어 10개의 값을 가지고 옴
            }
            return _buildRow(snapshot.data, _suggestions[realIndex]);
          });
        });
  }

  Widget _buildRow(Set<WordPair> saved, WordPair pair) {
    final bool alreadySaved =
        saved == null ? false : saved.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        textScaleFactor: 1.5,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        //alreadySaved가 참이면 하트, 거짓이면 구멍난 하트
        color: Colors.pink,
      ), //trailing = 끝부분에 넣는 것
      onTap: () {
        //클릭을 하면
        bloc.addToOrRemoveFromSavedList(pair);
      },
    );
  }
}
