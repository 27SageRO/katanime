import 'package:equatable/equatable.dart';

abstract class AnimeDetailsEvent extends Equatable {
  const AnimeDetailsEvent();
}

class AnimeDetailsEventReload extends AnimeDetailsEvent {
  final int malId;
  const AnimeDetailsEventReload(this.malId);
  @override
  List<Object> get props => [];
}
