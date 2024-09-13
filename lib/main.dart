import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherclean/core/widget/main_wrapper.dart';
import 'package:weatherclean/features/bookamark_feature/presentation/bloc/bookmark_bloc.dart';
import 'package:weatherclean/features/weather_feature/presentation/bloc/home_bloc.dart';
import 'package:weatherclean/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();

  runApp(MultiBlocProvider(
    providers: [ BlocProvider(create: (_) => locator<HomeBloc>()),
      BlocProvider(create: (_)=>  locator<BookmarkBloc>()),],
    child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blueAccent,
          useMaterial3: true,
        ),
        home: MainWrapper()),
  ),);
}
