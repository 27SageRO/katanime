import 'package:equatable/equatable.dart';
import 'package:jikan_api/jikan_api.dart';

abstract class DiscoverState extends Equatable {
  const DiscoverState();
  @override
  List<Object> get props => [];
}

class DiscoverStateLoading extends DiscoverState {}

class DiscoverStateError extends DiscoverState {}

class DiscoverStateSuccess extends DiscoverState {
  final Season seasonAnime;
  final List<Top> topAnime;
  final List<Top> topUpcomingAnime;

  const DiscoverStateSuccess({
    this.seasonAnime,
    this.topAnime,
    this.topUpcomingAnime,
  });

  DiscoverStateSuccess copyWith({
    Season seasonAnime,
    List<Top> topAnime,
    List<Top> topUpcomingAnime,
  }) {
    return DiscoverStateSuccess(
      seasonAnime: seasonAnime ?? this.seasonAnime,
      topAnime: topAnime ?? this.topAnime,
      topUpcomingAnime: topUpcomingAnime ?? this.topUpcomingAnime,
    );
  }

  @override
  List<Object> get props => [
        seasonAnime,
        topAnime,
        topUpcomingAnime,
      ];
}
