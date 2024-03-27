import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import '../services/get_data_services.dart.dart';
import 'app_cubit_states.dart';

class AppCubits extends Cubit<CubitStates> {
  AppCubits({
    required this.data,
  }) : super(InitialState()) {
    emit(WelcomeState());
  }
  final DataServices data;
  late final places;

  Future<void> getData(String apiUrl) async {
    try {
      emit(LoadingState());
      places = await data.getInfo(apiUrl);
      log(places.toString(), name: 'CUBIT GOT IT');
      emit(LoadedState(places));
    } catch (e) {}
  }
}
