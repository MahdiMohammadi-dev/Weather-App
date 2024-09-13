import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherclean/core/widget/dot_loading_widget.dart';
import 'package:weatherclean/features/bookamark_feature/domain/entities/city_entity.dart';
import 'package:weatherclean/features/bookamark_feature/presentation/bloc/bookmark_bloc.dart';
import 'package:weatherclean/features/bookamark_feature/presentation/bloc/get_all_city_status.dart';
import 'package:weatherclean/features/weather_feature/presentation/bloc/home_bloc.dart';

class BookmarkScreen extends StatelessWidget {
  final PageController pageController;
  const BookmarkScreen({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    BlocProvider.of<BookmarkBloc>(context).add(GetAllCityEvent());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<BookmarkBloc, BookmarkState>(
        buildWhen: (previous, current) {
          if (current.getAllCityStatus == previous.getAllCityStatus) {
            return false;
          }
          return true;
        },
        builder: (context, state) {
          if (state.getAllCityStatus is GetAllCityLoading) {
            return const Expanded(child: DotLoadingWidget());
          }
          if (state.getAllCityStatus is GetAllCityCompleted) {
            GetAllCityCompleted getAllCityCompleted =
                state.getAllCityStatus as GetAllCityCompleted;
            List<City> cities = getAllCityCompleted.cities;

            return SafeArea(
                child: Column(
              children: [
                const Text(
                  'Bookmark City List',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: cities.isEmpty
                        ? const Center(
                            child: Text(
                              'City is Empty',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          )
                        : ListView.builder(
                            itemCount: cities.length,
                            itemBuilder: (context, index) {
                              City city = cities[index];
                           return GestureDetector(
                                onTap: () {
                                  BlocProvider.of<HomeBloc>(context)
                                      .add(LoadCwEvent(city.name));

                                  pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.bounceIn);

                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: ClipRect(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 5.0, sigmaY: 5.0),
                                      child: Container(
                                        width: size.width,
                                        height: 60.0,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          color: Colors.grey.withOpacity(0.1),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                city.name,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  BlocProvider.of<BookmarkBloc>(
                                                          context)
                                                      .add(DeleteCityEvent(
                                                          city.name));
                                                  BlocProvider.of<BookmarkBloc>(
                                                          context)
                                                      .add(GetAllCityEvent());
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.redAccent,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )),
              ],
            ));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
