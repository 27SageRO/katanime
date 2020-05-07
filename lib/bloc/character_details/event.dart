import 'package:equatable/equatable.dart';

abstract class CharacterDetailsEvent extends Equatable {
  const CharacterDetailsEvent();
}

class CharacterDetailsEventReload extends CharacterDetailsEvent {
  final int malId;
  const CharacterDetailsEventReload(this.malId);
  @override
  List<Object> get props => [];
}
