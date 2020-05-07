import 'package:equatable/equatable.dart';

class MangaSearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MangaSearchEventFetch extends MangaSearchEvent {
  final String query;
  MangaSearchEventFetch(this.query);
  @override
  List<Object> get props => [query];
}
