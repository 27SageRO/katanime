import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:katanime/bloc/manga_details/bloc.dart';
import 'package:katanime/bloc/manga_details/event.dart';
import 'package:katanime/bloc/manga_details/state.dart';
import 'package:katanime/res/R.dart';
import 'package:katanime/screen/manga_details/widget/characters.dart';
import 'package:katanime/screen/manga_details/widget/overview.dart';
import 'package:katanime/screen/manga_details/widget/reviews.dart';

class MangaDetailsScreenArgs {
  final int malId;
  const MangaDetailsScreenArgs(this.malId);
}

class MangaDetailsScreen extends StatefulWidget {
  final int malId;
  const MangaDetailsScreen(this.malId, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MangaDetailsState(malId);
  }
}

class _MangaDetailsState extends State<MangaDetailsScreen> {
  final int malId;
  MangaDetailsBloc bloc;
  int controlValue = 0;

  Map<int, Widget> controls = {
    0: _buildControllerItem('Overview'),
    1: _buildControllerItem('Characters'),
    2: _buildControllerItem('Reviews'),
  };

  _MangaDetailsState(this.malId);

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<MangaDetailsBloc>(context);
    bloc.add(MangaDetailsEventFetch(malId));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.white60,
        border: null,
        leading: CupertinoNavigationBarBackButton(
          previousPageTitle: 'Back',
          onPressed: () => Navigator.of(context).pop(),
          color: KatanimeColors.portage,
        ),
      ),
      child: BlocBuilder<MangaDetailsBloc, MangaDetailsState>(
        builder: (context, state) {
          if (state is MangaDetailsStateLoading) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }

          if (state is MangaDetailsStateError) {
            return Center(
              child: Text('There\'s an error occured.'),
            );
          }

          if (state is MangaDetailsStateSuccess) {
            return CustomScrollView(
              slivers: <Widget>[
                SliverSafeArea(
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _Header(manga: state.manga),
                      CupertinoSegmentedControl(
                        borderColor: KatanimeColors.portage,
                        selectedColor: KatanimeColors.portage,
                        groupValue: controlValue,
                        children: controls,
                        onValueChanged: _handleController,
                      ),
                    ]),
                  ),
                ),
                if (controlValue == 0)
                  MangaDetailsOverview(
                    manga: state.manga,
                  ),
                if (controlValue == 1)
                  MangaDetailsCharacters(
                    characters: state.characters,
                    manga: state.manga,
                  ),
                if (controlValue == 2)
                  MangaDetailsReviews(reviews: state.reviews),
              ],
            );
          }

          return null;
        },
      ),
    );
  }

  static Widget _buildControllerItem(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15,
        fontFamily: 'Montserrat',
      ),
    );
  }

  _handleController(int val) {
    this.setState(() {
      this.controlValue = val;
    });
  }
}

class _Header extends StatelessWidget {
  final Manga manga;
  const _Header({Key key, this.manga}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 8, 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                manga.imageUrl,
                fit: BoxFit.cover,
                height: double.infinity,
                width: 80,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(4, 8, 4, 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    manga.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${manga.chapters ?? 0} Chapters - ${manga.members} members',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(8, 16, 16, 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Column(
                children: <Widget>[
                  Text(
                    'Score',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: KatanimeColors.gradient,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(12, 6, 12, 6),
                      child: Text(
                        '${manga.score ?? 0.0}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
