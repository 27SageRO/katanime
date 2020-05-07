import 'package:equatable/equatable.dart';

abstract class MangaDetailsEvent extends Equatable {
  const MangaDetailsEvent();
}

class MangaDetailsEventFetch extends MangaDetailsEvent {
  final int malId;
  MangaDetailsEventFetch(this.malId);
  @override
  List<Object> get props => [malId];
}
