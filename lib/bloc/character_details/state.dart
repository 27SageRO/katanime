import 'package:equatable/equatable.dart';
import 'package:jikan_api/jikan_api.dart';

abstract class CharacterDetailsState extends Equatable {
  const CharacterDetailsState();
  @override
  List<Object> get props => [];
}

class CharacterDetailsStateLoading extends CharacterDetailsState {}

class CharacterDetailsStateError extends CharacterDetailsState {}

class CharacterDetailsStateSuccess extends CharacterDetailsState {
  final Character character;

  const CharacterDetailsStateSuccess({
    this.character,
  });

  CharacterDetailsStateSuccess copyWith({
    Character character,
  }) {
    return CharacterDetailsStateSuccess(
      character: character ?? this.character,
    );
  }

  @override
  List<Object> get props => [character];
}
