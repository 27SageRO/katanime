import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';

class MangaDetailsOverview extends StatelessWidget {
  final Manga manga;
  const MangaDetailsOverview({Key key, this.manga}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        _Synopsis(manga: manga),
        Divider(color: CupertinoColors.systemGrey3),
        _AlternativeTitles(manga: manga),
        Divider(color: CupertinoColors.systemGrey3),
        _Information(manga: manga),
        Divider(color: CupertinoColors.systemGrey3),
        _Statistics(manga: manga),
      ]),
    );
  }
}

class _Synopsis extends StatelessWidget {
  final Manga manga;
  const _Synopsis({Key key, this.manga}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _SectionItem(
      title: 'Synopsis',
      children: <Widget>[
        SizedBox(height: 8),
        Text(
          manga.synopsis,
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
  final Manga manga;

  const _AlternativeTitles({Key key, this.manga}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _SectionItem(
      title: 'Alternative Titles',
      children: <Widget>[
        _SectionLineItem(
          title: 'English',
          value: '${manga.titleEnglish ?? 'N/A'}',
        ),
        _SectionLineItem(
          title: 'Japanese',
          value: manga.titleJapanese,
        ),
      ],
    );
  }
}

class _Information extends StatelessWidget {
  final Manga manga;
  const _Information({Key key, this.manga}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _SectionItem(
      title: 'Information',
      children: <Widget>[
        _SectionLineItem(title: 'Type', value: manga.type),
        _SectionLineItem(title: 'Volumes', value: manga.status),
        _SectionLineItem(title: 'Chapters', value: manga.chapters.toString()),
        _SectionLineItem(title: 'Status', value: manga.status),
        _SectionLineItem(title: 'Published', value: manga.published.string),
        _SectionLineItem(
          title: 'Genres',
          value: manga.genres.map((o) {
            return o.name;
          }).join(', '),
        ),
        _SectionLineItem(
          title: 'Serialization',
          value: manga.serializations.map((o) {
            return o.name;
          }).join(', '),
        ),
      ],
    );
  }
}

class _Statistics extends StatelessWidget {
  final Manga manga;

  const _Statistics({Key key, this.manga}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _SectionItem(
      title: 'Statistics',
      children: <Widget>[
        _SectionLineItem(
          title: 'Score',
          value:
              '${manga.score ?? 0.0} (scored by ${manga.scoredBy ?? 0} users)',
        ),
        _SectionLineItem(
          title: 'Rank',
          value: '#${manga.rank ?? 0}',
        ),
        _SectionLineItem(
          title: 'Popularity',
          value: '#${manga.popularity}',
        ),
        _SectionLineItem(
          title: 'Members',
          value: manga.members.toString(),
        ),
        _SectionLineItem(
          title: 'Favorites',
          value: manga.favorites.toString(),
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
