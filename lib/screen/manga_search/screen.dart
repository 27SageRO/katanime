import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:katanime/bloc/manga_search/bloc.dart';
import 'package:katanime/bloc/manga_search/event.dart';
import 'package:katanime/bloc/manga_search/state.dart';
import 'package:katanime/res/R.dart';
import 'package:katanime/screen/manga_details/screen.dart';

class MangaSearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MangaSearchScreenState();
  }
}

class MangaSearchScreenState extends State<MangaSearchScreen> {
  final _textController = TextEditingController(text: '');
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  MangaSearchBloc _mangaSearchBloc;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onChangeText);
    _scrollController.addListener(_onScroll);
    _mangaSearchBloc = BlocProvider.of<MangaSearchBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: Container(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: CupertinoColors.systemGrey5,
          ),
          child: Row(
            children: <Widget>[
              Icon(
                CupertinoIcons.search,
                color: CupertinoColors.inactiveGray,
                size: 18,
              ),
              Flexible(
                child: CupertinoTextField(
                  style: TextStyle(fontSize: 16),
                  controller: _textController,
                  clearButtonMode: OverlayVisibilityMode.editing,
                  decoration: BoxDecoration(color: Colors.transparent),
                  placeholder: 'Search your favorite manga',
                ),
              ),
            ],
          ),
        ),
      ),
      child: BlocBuilder<MangaSearchBloc, MangaSearchState>(
        builder: (context, state) {
          if (state is MangaSearchStateEmpty) {
            return Container();
          }

          if (state is MangaSearchStateError) {
            return Center(child: Text('There\s an error occured'));
          }

          if (state is MangaSearchStateLoading) {
            return Center(child: CupertinoActivityIndicator());
          }

          if (state is MangaSearchStateSuccess) {
            return ListView.builder(
              itemCount: state.mangas.length,
              itemBuilder: (context, index) {
                final manga = state.mangas[index];
                return _Manga(manga: manga);
              },
              controller: _scrollController,
            );
          }
          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onChangeText() {
    final text = _textController.text;
    if (text.length > 2) {
      _mangaSearchBloc.add(MangaSearchEventFetch(text));
    }
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final text = _textController.text;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _mangaSearchBloc.add(MangaSearchEventFetch(text));
    }
  }
}

class _Manga extends StatelessWidget {
  final Search manga;
  const _Manga({Key key, this.manga}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            'MangaDetails',
            arguments: MangaDetailsScreenArgs(manga.malId),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                manga.imageUrl,
                fit: BoxFit.cover,
                height: 150,
                width: 180,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      manga.title,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Score',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(99),
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: KatanimeColors.gradient,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                              child: Text(
                                manga.score.toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      ' ${manga.chapters} chapters',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
