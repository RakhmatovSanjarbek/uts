import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

abstract class LanguageEvent {}
class ChangeLanguage extends LanguageEvent {
  final BuildContext context;
  final Locale locale;
  ChangeLanguage(this.context, this.locale);
}

class LanguageState {
  final Locale locale;
  LanguageState(this.locale);
}

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageState(const Locale('uz'))) {
    on<ChangeLanguage>((event, emit) async {
      await event.context.setLocale(event.locale);
      emit(LanguageState(event.locale));
    });
  }
}