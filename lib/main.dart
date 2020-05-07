import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:katanime/bloc/anime_details/bloc.dart';
import 'package:katanime/bloc/anime_search/bloc.dart';
import 'package:katanime/bloc/character_details/bloc.dart';
import 'package:katanime/bloc/discover/bloc.dart';
import 'package:katanime/bloc/manga_search/bloc.dart';
import 'package:katanime/screen/anime_details/screen.dart';
import 'package:katanime/screen/anime_search/screen.dart';
import 'package:katanime/screen/character_details/screen.dart';
import 'package:katanime/screen/discover/screen.dart';
import 'package:katanime/screen/manga_details/screen.dart';
import 'package:katanime/screen/manga_search/screen.dart';

import 'bloc/manga_details/bloc.dart';

void main() {
  BlocSupervisor.delegate = _BlocLoggerDelegate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Katanime',
      initialRoute: 'Discover',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case 'Discover':
            FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
            return CupertinoPageRoute(
              builder: (_) => BlocProvider(
                create: (context) => DiscoverBloc(new Jikan()),
                child: DiscoverScreen(),
              ),
              settings: settings,
            );
          case 'AnimeSearch':
            return CupertinoPageRoute(
              builder: (_) => BlocProvider(
                create: (context) => AnimeSearchBloc(new Jikan()),
                child: AnimeSearchScreen(),
              ),
              settings: settings,
            );
          case 'MangaSearch':
            return CupertinoPageRoute(
              builder: (_) => BlocProvider(
                create: (context) => MangaSearchBloc(new Jikan()),
                child: MangaSearchScreen(),
              ),
              settings: settings,
            );
          case 'AnimeDetails':
            final AnimeDetailsScreenArgs args = settings.arguments;
            return CupertinoPageRoute(
              builder: (_) => BlocProvider(
                create: (context) => AnimeDetailsBloc(new Jikan()),
                child: AnimeDetailsScreen(args.malId),
              ),
              settings: settings,
            );
          case 'MangaDetails':
            final MangaDetailsScreenArgs args = settings.arguments;
            return CupertinoPageRoute(
              builder: (_) => BlocProvider(
                create: (context) => MangaDetailsBloc(new Jikan()),
                child: MangaDetailsScreen(args.malId),
              ),
              settings: settings,
            );
          case 'CharacterDetails':
            final CharacterDetailsScreenArgs args = settings.arguments;
            return CupertinoPageRoute(
              builder: (_) => BlocProvider(
                create: (context) => CharacterDetailsBloc(new Jikan()),
                child: CharacterDetailsScreen(
                  character: args.character,
                  anime: args.anime,
                  manga: args.manga,
                ),
              ),
            );
        }
        return null;
      },
    );
  }
}

class _BlocLoggerDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    print(error);
    super.onError(bloc, error, stacktrace);
  }
}
