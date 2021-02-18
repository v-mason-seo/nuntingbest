import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ntbest/data/entities/best_post.dart';

import '../../data/api/api.dart';

class ReportScreen extends StatelessWidget {
  final BestPost content; 
  const ReportScreen({Key key, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(backgroundColor: Colors.teal, title: Text("신고"),) ,
    body: 
    Center(child: 
    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 50),
      Text(content.title , style: TextStyle(color: Colors.redAccent, fontSize: 20)),
      SizedBox(height: 20),
      Text(content.url),
      SizedBox(height: 20),
      FlatButton(
        color: Colors.redAccent,
        onPressed: ()  async {
          await Api().deletedContent(content.url);
          await Fluttertoast.showToast(
                msg: "삭제 신고 처리 되었습니다.", gravity: ToastGravity.TOP);
          Navigator.pop(context);
        },
        child: Text("신고하기"),
      )
    ],
    )
    )
    );
  }
}