import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:katanime/bloc/anime_details/bloc.dart';
import 'package:katanime/bloc/anime_details/event.dart';
import 'package:katanime/bloc/anime_details/state.dart';
import 'package:katanime/res/R.dart';
import 'package:katanime/screen/anime_details/widget/characters.dart';
import 'package:katanime/screen/anime_details/widget/overview.dart';
import 'package:katanime/screen/anime_details/widget/reviews.dart';

class AnimeDetailsScreenArgs {
  final int malId;
  const AnimeDetailsScreenArgs(this.malId);
}

class AnimeDetailsScreen extends StatelessWidget {
  final int malId;
  const AnimeDetailsScreen(this.malId, {Key key}) : super(key: key);

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
      child: _Page(malId: malId),
    );
  }
}

class _Page extends StatefulWidget {
  final int malId;
  const _Page({Key key, this.malId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PageState(malId: malId);
  }
}

class _PageState extends State<_Page> {
  final int malId;

  _PageState({@required this.malId});

  int controlValue = 0;

  Map<int, Widget> controls = {
    0: _buildControllerItem('Overview'),
    1: _buildControllerItem('Characters'),
    2: _buildControllerItem('Reviews'),
  };

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnimeDetailsBloc, AnimeDetailsState>(
      builder: (context, state) {
        if (state is AnimeDetailsStateLoading) {
          BlocProvider.of<AnimeDetailsBloc>(context)
              .add(AnimeDetailsEventReload(malId));
          return Center(
            child: CupertinoActivityIndicator(),
          );
        } else if (state is AnimeDetailsStateSuccess) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverSafeArea(
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _Header(anime: state.anime),
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
                AnimeDetailsOverview(
                  anime: state.anime,
                ),
              if (controlValue == 1)
                AnimeDetailsCharacters(
                  characterStaff: state.characterStaff,
                  anime: state.anime,
                ),
              if (controlValue == 2)
                AnimeDetailsReviews(
                  reviews: state.reviews,
                ),
            ],
          );
        }
        return null;
      },
    );
  }
}

class _Header extends StatelessWidget {
  final Anime anime;
  const _Header({Key key, this.anime}) : super(key: key);

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
                anime.imageUrl,
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
                    anime.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${anime.episodes ?? 0} Episodes - ${anime.members} members',
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
                        '${anime.score ?? 0.0}',
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
