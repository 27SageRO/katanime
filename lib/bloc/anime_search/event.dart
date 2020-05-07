import 'package:equatable/equatable.dart';

abstract class AnimeSearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AnimeSearchEventFetch extends AnimeSearchEvent {
  final String query;
  AnimeSearchEventFetch(this.query);
  @override
  List<Object> get props => [query];
}
