import 'dart:async';
import 'package:english_words/english_words.dart';

class Bloc {
  Set<WordPair> saved = Set<WordPair>();

  final _savedController = StreamController<Set<WordPair>>.broadcast();

  get savedStream => _savedController.stream; //stream를 받아올 수 있는 함수
  //=>는 한 줄 짜리 함수를 줄일 때 씀

  get addCurrentSaved =>_savedController.sink.add(saved);

  addToOrRemoveFromSavedList(WordPair item){
    if(saved.contains(item)){
      saved.remove(item);
    } else{
      saved.add(item);
    }
    _savedController.sink.add(saved); //변경된 데이터를 보내줄 때 sink를 씀
  }
  dispose() {
    //이걸 안하면 메모리 릭이 생길 수 있음
    _savedController.close();
  }
}

var bloc = Bloc();
