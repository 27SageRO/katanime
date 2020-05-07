import 'package:equatable/equatable.dart';
import 'package:jikan_api/jikan_api.dart';

abstract class MangaDetailsState extends Equatable {
  const MangaDetailsState();
  @override
  List<Object> get props => [];
}

class MangaDetailsStateLoading extends MangaDetailsState {}

class MangaDetailsStateError extends MangaDetailsState {}

class MangaDetailsStateSuccess extends MangaDetailsState {
  final Manga manga;
  final List<CharacterRole> characters;
  final List<Review> reviews;
  MangaDetailsStateSuccess({this.manga, this.characters, this.reviews});

  MangaDetailsStateSuccess copyWith({
    Manga manga,
    List<CharacterRole> characters,
    List<Review> reviews,
  }) {
    return MangaDetailsStateSuccess(
      manga: manga ?? this.manga,
      characters: characters ?? this.characters,
      reviews: reviews ?? this.reviews,
    );
  }

  @override
  List<Object> get props => [manga, characters, reviews];
}
