import 'package:equatable/equatable.dart';

abstract class DiscoverEvent extends Equatable {
  const DiscoverEvent();
}

class DiscoverEventReload extends DiscoverEvent {
  const DiscoverEventReload();
  @override
  List<Object> get props => [];
}
