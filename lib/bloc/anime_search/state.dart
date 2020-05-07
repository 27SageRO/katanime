import 'package:equatable/equatable.dart';
import 'package:jikan_api/jikan_api.dart';

abstract class AnimeSearchState extends Equatable {
  @override
  List<Object> get props => [];
}

class AnimeSearchStateEmpty extends AnimeSearchState {}

class AnimeSearchStateLoading extends AnimeSearchState {}

class AnimeSearchStateError extends AnimeSearchState {}

class AnimeSearchStateSuccess extends AnimeSearchState {
  final List<Search> animes;
  final int page;
  final String query;
  final bool hasReachedMax;
  AnimeSearchStateSuccess({
    this.animes,
    this.query,
    this.page = 1,
    this.hasReachedMax = false,
  });
  AnimeSearchStateSuccess copyWith({
    List<Search> animes,
    int page,
    String query,
    bool hasReachedMax,
  }) {
    return AnimeSearchStateSuccess(
      animes: animes ?? this.animes,
      page: page ?? this.page,
      query: query ?? this.query,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [animes, page, query, hasReachedMax];
}
