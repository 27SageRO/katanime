import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:katanime/bloc/character_details/bloc.dart';
import 'package:katanime/bloc/character_details/event.dart';
import 'package:katanime/bloc/character_details/state.dart';
import 'package:katanime/res/R.dart';
import 'package:katanime/screen/anime_details/screen.dart';

class CharacterDetailsScreenArgs {
  final CharacterRole character;
  final Anime anime;
  final Manga manga;
  const CharacterDetailsScreenArgs({
    this.character,
    this.anime,
    this.manga,
  });
}

class CharacterDetailsScreen extends StatelessWidget {
  final CharacterRole character;
  final Anime anime;
  final Manga manga;
  const CharacterDetailsScreen({
    Key key,
    this.character,
    this.anime,
    this.manga,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.white,
        border: null,
        middle: Text(anime.title ?? manga.title),
        leading: CupertinoNavigationBarBackButton(
          previousPageTitle: 'Back',
          onPressed: () => Navigator.of(context).pop(),
          color: KatanimeColors.portage,
        ),
      ),
      child: _Body(character.malId),
    );
  }
}

class _Body extends StatelessWidget {
  final int malId;
  const _Body(this.malId, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterDetailsBloc, CharacterDetailsState>(
      builder: (context, state) {
        if (state is CharacterDetailsStateLoading) {
          BlocProvider.of<CharacterDetailsBloc>(context)
              .add(CharacterDetailsEventReload(malId));
          return Center(
            child: CupertinoActivityIndicator(),
          );
        } else if (state is CharacterDetailsStateSuccess) {
          final character = state.character;
          final voiceActors = state.character.voiceActors;

          return CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Stack(
                  children: <Widget>[
                    ClipRect(
                      child: Container(
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(character.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          height: 160,
                          child: Column(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.network(
                                  character.imageUrl,
                                  fit: BoxFit.cover,
                                  height: 120,
                                  width: 120,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                character.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                character.nameKanji ?? '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  _SectionItem(
                    title: 'About',
                    children: <Widget>[
                      SizedBox(height: 8),
                      Text(
                        character.about.replaceAll('\\n', ''),
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Divider(color: CupertinoColors.systemGrey3),
                ]),
              ),
              if (voiceActors.length > 0)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Voice Actors',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              if (voiceActors.length > 0)
                SliverToBoxAdapter(
                  child: Container(
                    height: 130,
                    child: ListView.builder(
                      padding: EdgeInsets.fromLTRB(16, 0, 0, 8),
                      scrollDirection: Axis.horizontal,
                      itemCount: voiceActors.length,
                      itemBuilder: (context, index) {
                        final actor = voiceActors[index];
                        return _VoiceActor(actor: actor);
                      },
                    ),
                  ),
                ),
              if (character.animeography.length > 0)
                SliverList(
                  delegate: SliverChildListDelegate([
                    Divider(color: CupertinoColors.systemGrey3),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Animeography',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    for (final role in character.animeography)
                      _Role(role: role, type: 'anime')
                  ]),
                ),
              if (character.mangaography.length > 0)
                SliverList(
                  delegate: SliverChildListDelegate([
                    Divider(color: CupertinoColors.systemGrey3),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Animeography',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    for (final role in character.mangaography)
                      _Role(role: role, type: 'manga')
                  ]),
                )
            ],
          );
        }
        return null;
      },
    );
  }
}

class _VoiceActor extends StatelessWidget {
  final VoiceActor actor;
  const _VoiceActor({Key key, this.actor}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 16),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.network(
              actor.imageUrl,
              fit: BoxFit.cover,
              height: 80,
              width: 80,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              actor.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            actor.language,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _Role extends StatelessWidget {
  final CharacterRole role;
  final String type;
  const _Role({Key key, this.role, this.type}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (type == 'anime') {
          Navigator.pushNamed(
            context,
            'AnimeDetails',
            arguments: AnimeDetailsScreenArgs(role.malId),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                role.imageUrl,
                fit: BoxFit.cover,
                height: 120,
                width: 80,
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      role.name,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      role.role,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
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
      ),
    );
  }
}
