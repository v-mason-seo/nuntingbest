import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {

  final String errorMessage;
  final VoidCallback onPressed;

  ErrorPage({
    this.errorMessage = "에러가 발생했습니다.",
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.error_outline, color: Colors.red, size: 48.0,),
          SizedBox(height: 64,),
          Text(errorMessage, style: TextStyle(color: Colors.red.shade400),),
          SizedBox(height: 32,),
          RaisedButton(
            child: Text('다시시도'),
            onPressed: onPressed,
          )
        ],
      ),
    );    
  }
}