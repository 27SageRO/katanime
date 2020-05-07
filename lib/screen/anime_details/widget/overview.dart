import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';

class AnimeDetailsOverview extends StatelessWidget {
  final Anime anime;
  const AnimeDetailsOverview({Key key, this.anime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        _Synopsis(anime: anime),
        Divider(color: CupertinoColors.systemGrey3),
        _AlternativeTitles(anime: anime),
        Divider(color: CupertinoColors.systemGrey3),
        _Information(anime: anime),
        Divider(color: CupertinoColors.systemGrey3),
        _Statistics(anime: anime),
      ]),
    );
  }
}

class _Synopsis extends StatelessWidget {
  final Anime anime;
  const _Synopsis({Key key, this.anime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _SectionItem(
      title: 'Synopsis',
      children: <Widget>[
        SizedBox(height: 8),
        Text(
          anime.synopsis,
          style: TextStyle(
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _AlternativeTitles extends StatelessWidget {
  final Anime anime;

  const _AlternativeTitles({Key key, this.anime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _SectionItem(
      title: 'Alternative Titles',
      children: <Widget>[
        _SectionLineItem(
          title: 'English',
          value: '${anime.titleEnglish ?? 'N/A'}',
        ),
        _SectionLineItem(
          title: 'Japanese',
          value: anime.titleJapanese,
        ),
      ],
    );
  }
}

class _Information extends StatelessWidget {
  final Anime anime;
  const _Information({Key key, this.anime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _SectionItem(
      title: 'Information',
      children: <Widget>[
        _SectionLineItem(title: 'Type', value: anime.type),
        _SectionLineItem(title: 'Status', value: anime.status),
        _SectionLineItem(title: 'Premiered', value: anime.premiered),
        _SectionLineItem(title: 'Aired', value: anime.aired.string),
        _SectionLineItem(title: 'Broadcast', value: anime.broadcast),
        _SectionLineItem(
          title: 'Producers',
          value: anime.producers.map((o) {
            return o.name;
          }).join(', '),
        ),
        _SectionLineItem(
          title: 'Licensors',
          value: anime.licensors.map((o) {
            return o.name;
          }).join(', '),
        ),
        _SectionLineItem(
          title: 'Studios',
          value: anime.studios.map((o) {
            return o.name;
          }).join(', '),
        ),
        _SectionLineItem(title: 'Source', value: anime.source),
        _SectionLineItem(
          title: 'Genres',
          value: anime.genres.map((o) {
            return o.name;
          }).join(', '),
        ),
        _SectionLineItem(title: 'Duration', value: anime.duration),
      ],
    );
  }
}

class _Statistics extends StatelessWidget {
  final Anime anime;

  const _Statistics({Key key, this.anime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _SectionItem(
      title: 'Statistics',
      children: <Widget>[
        _SectionLineItem(
          title: 'Score',
          value:
              '${anime.score ?? 0.0} (scored by ${anime.scoredBy ?? 0} users)',
        ),
        _SectionLineItem(
          title: 'Rank',
          value: '#${anime.rank ?? 0}',
        ),
        _SectionLineItem(
          title: 'Popularity',
          value: '#${anime.popularity}',
        ),
        _SectionLineItem(
          title: 'Members',
          value: anime.members.toString(),
        ),
        _SectionLineItem(
          title: 'Favorites',
          value: anime.favorites.toString(),
        ),
      ],
    );
  }
}

class _SectionItem extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionItem({
    Key key,
    this.title,
    this.children = const <Widget>[],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          ...children,
        ],
      ),
    ));
  }
}

class _SectionLineItem extends StatelessWidget {
  final String title;
  final String value;
  final double width;

  const _SectionLineItem({
    Key key,
    this.title,
    this.value,
    this.width = 80,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: width,
            child: Text(
              '$title ',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '$value',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
