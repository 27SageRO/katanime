import 'package:equatable/equatable.dart';
import 'package:jikan_api/jikan_api.dart';

abstract class AnimeDetailsState extends Equatable {
  const AnimeDetailsState();
  @override
  List<Object> get props => [];
}

class AnimeDetailsStateLoading extends AnimeDetailsState {}

class AnimeDetailsStateError extends AnimeDetailsState {}

class AnimeDetailsStateSuccess extends AnimeDetailsState {
  final Anime anime;
  final CharacterStaff characterStaff;
  final List<Review> reviews;

  const AnimeDetailsStateSuccess({
    this.anime,
    this.characterStaff,
    this.reviews,
  });

  AnimeDetailsStateSuccess copyWith({
    Anime anime,
    CharacterStaff characterStaff,
    List<Review> reviews,
  }) {
    return AnimeDetailsStateSuccess(
      anime: anime ?? this.anime,
      characterStaff: characterStaff ?? this.characterStaff,
      reviews: reviews ?? this.reviews,
    );
  }

  @override
  List<Object> get props => [anime, characterStaff, reviews];
}
