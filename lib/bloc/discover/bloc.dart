import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:katanime/bloc/discover/event.dart';
import 'package:katanime/bloc/discover/state.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final Jikan api;

  DiscoverBloc(this.api);

  @override
  DiscoverState get initialState => DiscoverStateLoading();

  @override
  Stream<DiscoverState> mapEventToState(event) async* {
    if (event is DiscoverEventReload) {
      yield DiscoverStateLoading();
      try {
        final seasonAnime = await api.getSeason();
        yield DiscoverStateSuccess(seasonAnime: seasonAnime);

        // Lazy load:
        var currentState = state;
        if (currentState is DiscoverStateSuccess) {
          final topAnime = await api.getTop(TopType.anime);
          yield currentState.copyWith(topAnime: topAnime.toList());
        }

        currentState = state;
        if (currentState is DiscoverStateSuccess) {
          final topUpcomingAnime =
              await api.getTop(TopType.anime, subtype: TopSubtype.upcoming);
          yield currentState.copyWith(
              topUpcomingAnime: topUpcomingAnime.toList());
        }
      } catch (e) {
        DiscoverStateError();
      }
    }
  }
}
