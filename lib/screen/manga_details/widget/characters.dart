import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:katanime/screen/character_details/screen.dart';

class MangaDetailsCharacters extends StatelessWidget {
  final List<CharacterRole> characters;
  final Manga manga;
  const MangaDetailsCharacters({
    Key key,
    this.characters,
    this.manga,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (characters == null) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: CupertinoActivityIndicator(),
        ),
      );
    }

    var size = MediaQuery.of(context).size;

    final double itemHeight = 250;
    final double itemWidth = size.width / 2;

    return SliverPadding(
      padding: EdgeInsets.all(16),
      sliver: SliverGrid.count(
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        crossAxisCount: 2,
        childAspectRatio: (itemWidth / itemHeight),
        children: <Widget>[
          for (final character in characters)
            GestureDetector(
              onTap: () => Navigator.pushNamed(
                context,
                'CharacterDetails',
                arguments: CharacterDetailsScreenArgs(
                  character: character,
                  manga: manga,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.network(
                      character.imageUrl,
                      fit: BoxFit.cover,
                      height: 180,
                      width: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      character.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    character.role,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
