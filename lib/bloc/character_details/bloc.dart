import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:katanime/bloc/character_details/event.dart';
import 'package:katanime/bloc/character_details/state.dart';

class CharacterDetailsBloc
    extends Bloc<CharacterDetailsEvent, CharacterDetailsState> {
  final Jikan api;

  CharacterDetailsBloc(this.api);

  @override
  CharacterDetailsState get initialState => CharacterDetailsStateLoading();

  @override
  Stream<CharacterDetailsState> mapEventToState(
      CharacterDetailsEvent event) async* {
    if (event is CharacterDetailsEventReload) {
      try {
        final character = await api.getCharacterInfo(event.malId);
        yield CharacterDetailsStateSuccess(character: character);
      } catch (e) {
        yield CharacterDetailsStateError();
      }
    }
  }
}
