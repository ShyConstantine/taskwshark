import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskwshark/cubit/app_cubit_states.dart';
import 'package:taskwshark/cubit/app_cubits.dart';
import 'package:taskwshark/presentation/home/screen/home_screen.dart';
import 'package:taskwshark/presentation/results/results_screen.dart';

class AppCubitLogics extends StatefulWidget {
  const AppCubitLogics({super.key});

  @override
  State<AppCubitLogics> createState() => _AppCubitLogicsState();
}

class _AppCubitLogicsState extends State<AppCubitLogics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppCubits, CubitStates>(
        builder: (BuildContext context, CubitStates state) {
          if (state is InitialState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WelcomeState) {
            return const HomeScreen();
          }

          if (state is LoadedState) {
            return const ResultsScreen();
          }
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('Error'));
          }
        },
      ),
    );
  }
}
