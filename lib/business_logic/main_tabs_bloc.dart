import 'package:flutter_bloc/flutter_bloc.dart';

class MainTabsBloc extends Bloc<ChangeTabEvent, int> {
  MainTabsBloc() : super(0) {
    on<ChangeTabEvent>((event, emit) => emit(event.tabIndex));
  }
}

class ChangeTabEvent {
  int tabIndex;
  ChangeTabEvent(this.tabIndex);
}
