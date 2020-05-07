import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:katanime/bloc/discover/bloc.dart';
import 'package:katanime/bloc/discover/event.dart';
import 'package:katanime/bloc/discover/state.dart';
import 'package:katanime/res/R.dart';
import 'package:katanime/screen/anime_details/screen.dart';

class DiscoverScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            CupertinoSliverNavigationBar(
              largeTitle: Text(
                'Discover',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            )
          ];
        },
        body: _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoverBloc, DiscoverState>(
      builder: (context, state) {
        if (state is DiscoverStateLoading) {
          BlocProvider.of<DiscoverBloc>(context).add(DiscoverEventReload());
          return Center(
            child: CupertinoActivityIndicator(),
          );
        } else if (state is DiscoverStateSuccess) {
          return CustomScrollView(
            slivers: <Widget>[
              _Button(
                title: 'Search Anime',
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                onTap: () {
                  Navigator.pushNamed(context, 'AnimeSearch');
                },
              ),
              _Button(
                title: 'Search Manga',
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                onTap: () {
                  Navigator.pushNamed(context, 'MangaSearch');
                },
              ),
              ...buildSeasonAnime(state.seasonAnime),
              ...buildTopAnime(state.topAnime),
              ...buildTopUpcomingAnime(state.topUpcomingAnime),
            ],
          );
        }
        return null;
      },
    );
  }
}

class _Button extends StatelessWidget {
  final String title;
  final void Function() onTap;
  final EdgeInsets padding;

  const _Button({Key key, this.title, this.onTap, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text(
                      title,
                      style: TextStyle(
                        color: KatanimeColors.portage,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                    size: 24.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                ],
              ),
              SizedBox(height: 8),
              Divider(
                color: CupertinoColors.systemGrey3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Widget> buildSeasonAnime(Season season) {
  return [
    _SectionTitle(
      title: '${season.seasonName} ${season.seasonYear} Anime'.toUpperCase(),
    ),
    SliverToBoxAdapter(
      child: Container(
        height: 290,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: season.anime.length,
          itemBuilder: (context, index) {
            final AnimeItem anime = season.anime[index];
            return _Anime(
              malId: anime.malId,
              imageUrl: anime.imageUrl,
              title: anime.title,
              score: anime.score,
              episodes: anime.episodes,
              type: anime.type,
            );
          },
        ),
      ),
    ),
  ];
}

List<Widget> buildTopAnime(List<Top> animes) {
  if (animes == null) {
    return [];
  }

  return [
    _SectionTitle(
      title: 'TOP ANIME',
    ),
    SliverToBoxAdapter(
      child: Container(
        height: 290,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: animes.length,
          itemBuilder: (context, index) {
            final Top anime = animes[index];
            return _Anime(
              malId: anime.malId,
              imageUrl: anime.imageUrl,
              title: anime.title,
              score: anime.score,
              episodes: anime.episodes,
              type: anime.type,
            );
          },
        ),
      ),
    ),
  ];
}

List<Widget> buildTopUpcomingAnime(List<Top> animes) {
  if (animes == null) {
    return [];
  }

  return [
    _SectionTitle(
      title: 'HIGHLY ANTICIPATED ANIME',
    ),
    SliverToBoxAdapter(
      child: Container(
        height: 290,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: animes.length,
          itemBuilder: (context, index) {
            final Top anime = animes[index];
            return _Anime(
              malId: anime.malId,
              imageUrl: anime.imageUrl,
              title: anime.title,
              score: anime.score,
              episodes: anime.episodes,
              type: anime.type,
            );
          },
        ),
      ),
    ),
  ];
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFixedExtentList(
      itemExtent: 37,
      delegate: SliverChildListDelegate([
        Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.black54,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class _Anime extends StatelessWidget {
  final int malId;
  final String imageUrl;
  final String title;
  final String type;
  final double score;
  final int episodes;

  const _Anime({
    Key key,
    this.malId,
    this.imageUrl,
    this.title,
    this.score,
    this.episodes,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 0, 8),
      width: 150.0,
      child: GestureDetector(
        onTap: () => {
          Navigator.pushNamed(
            context,
            'AnimeDetails',
            arguments: AnimeDetailsScreenArgs(malId),
          )
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2),
              child: Row(
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
                          score.toString(),
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
            ),
            Padding(
              padding: EdgeInsets.only(top: 2),
              child: Text(
                '$type - $episodes eps',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
