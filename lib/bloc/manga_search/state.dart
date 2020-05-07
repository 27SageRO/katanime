import 'package:equatable/equatable.dart';
import 'package:jikan_api/jikan_api.dart';

class MangaSearchState extends Equatable {
  @override
  List<Object> get props => [];
}

class MangaSearchStateEmpty extends MangaSearchState {}

class MangaSearchStateLoading extends MangaSearchState {}

class MangaSearchStateError extends MangaSearchState {}

class MangaSearchStateSuccess extends MangaSearchState {
  final List<Search> mangas;
  final int page;
  final String query;
  final bool hasReachedMax;
  MangaSearchStateSuccess({
    this.mangas,
    this.query,
    this.page = 1,
    this.hasReachedMax = false,
  });
  MangaSearchStateSuccess copyWith({
    List<Search> mangas,
    int page,
    String query,
    bool hasReachedMax,
  }) {
    return MangaSearchStateSuccess(
      mangas: mangas ?? this.mangas,
      page: page ?? this.page,
      query: query ?? this.query,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [mangas, page, query, hasReachedMax];
}
