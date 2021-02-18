import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ntbest/data/entities/board.dart';
import 'package:ntbest/data/entities/site.dart';
import 'package:ntbest/ui/pages/post_page.dart';

class PostListScreen extends StatelessWidget {

  final Site _site;

  PostListScreen({
    @required Site site
  }) : _site = site;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _site.boards.length,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: Scaffold(
          appBar: AppBar(
            title: Text('${_site.nm}'),
            bottom: TabBar(
              tabs: _site.boards.map((Board board) {
                return Tab(
                  text: board.bnm,
                );
              }).toList(),
            ),
          ),
          body: TabBarView(
            children: _pageList(),
          ),
        ),
      ),
    );
  }

  List<Widget> _pageList() {
    List<Widget> pageList = [];

    for(Board board in _site.boards) {
      Widget postPage = PostPage(site: _site, board: board,);
      pageList.add(postPage);
    }

    return pageList;
  }

}