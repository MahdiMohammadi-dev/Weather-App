import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:weatherclean/core/params/forecast_params.dart';
import 'package:weatherclean/core/widget/app_background.dart';
import 'package:weatherclean/core/widget/dot_loading_widget.dart';
import 'package:weatherclean/features/bookamark_feature/presentation/bloc/bookmark_bloc.dart';
import 'package:weatherclean/features/weather_feature/data/model/current_city_model.dart';
import 'package:weatherclean/features/weather_feature/data/model/forecast_days_model.dart';
import 'package:weatherclean/features/weather_feature/domain/entities/current_city_entitiy.dart';
import 'package:weatherclean/features/weather_feature/domain/entities/forecast_days_entity.dart';
import 'package:weatherclean/features/weather_feature/domain/usecases/get_suggestion_city_usecase.dart';
import 'package:weatherclean/features/weather_feature/presentation/bloc/cw_status.dart';
import 'package:weatherclean/features/weather_feature/presentation/bloc/fw_status.dart';
import 'package:weatherclean/features/weather_feature/presentation/bloc/home_bloc.dart';
import 'package:weatherclean/features/weather_feature/presentation/widget/bookmark_icon.dart';
import 'package:weatherclean/features/weather_feature/presentation/widget/days_weather_view.dart';
import 'package:weatherclean/locator.dart';

import '../../../../core/utils/date_converter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  final String cityName = 'Tehran';
  PageController _pageController = PageController();
  TextEditingController textEditingController = TextEditingController();

  GetSuggestionCityUseCase getSuggestionCityUseCase =
  GetSuggestionCityUseCase(locator());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(LoadCwEvent(cityName));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height * 0.02,
          ),

          /// Search box with bookmark section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
            child: Row(
              children: [
                Expanded(
                  child: TypeAheadField(
                    builder: (context, controller, focusNode) {
                      return TextField(
                        style: const TextStyle(color: Colors.white),
                        controller: controller,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Colors.white)),
                          enabled: true,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Colors.white)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Colors.white)),
                        ),
                      );
                    },
                    controller: textEditingController,
                    itemBuilder: (context, value) {
                      return ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(
                          value.name!,
                        ),
                        subtitle: Text(
                          "${value.region!}, ${value.country!}",
                        ),
                      );
                    },
                    onSelected: (value) {
                      textEditingController.text = value.name!;
                      BlocProvider.of<HomeBloc>(context)
                          .add(LoadCwEvent(value.name!));
                    },
                    suggestionsCallback: (search) {
                      return getSuggestionCityUseCase(search);
                    },
                  ),
                ),
                const SizedBox(width: 10,),

                BlocBuilder<HomeBloc, HomeState>(
                  buildWhen: (previous, current) {
                    if (previous.cwStatus == current.cwStatus) {
                      return false;
                    }
                    return true;
                  },
                  builder: (context, state) {
                    if (state.cwStatus is CwLoading) {
                      return const CircularProgressIndicator();
                    }
                    if(state.cwStatus is CwCompleted){
                      final CwCompleted cwCompleted = state.cwStatus as CwCompleted;
                      BlocProvider.of<BookmarkBloc>(context).add(GetCityByNameEvent(cwCompleted.currentCityEntity.name!));
                      return BookMarkIcon(name: cwCompleted.currentCityEntity.name!);
                    }
                    if (state.cwStatus is CwError) {
                      return const Icon(Icons.error, color: Colors.white, size: 20, );
                    }

                    return const SizedBox();
                  }
                  ,),

              ],
            ),
          ),


          /// Main Ui

          BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (previous, current) {
              if (previous.cwStatus == current.cwStatus) {
                return false;
              }
              return true;
            },
            builder: (context, state) {
              ///Loading State
              if (state.cwStatus is CwLoading) {
                return const Expanded(child: DotLoadingWidget());
              }

              /// Completed State
              if (state.cwStatus is CwCompleted) {
                final CwCompleted cwCompleted = state.cwStatus as CwCompleted;
                final CurrentCityEntity currentCityEntity =
                    cwCompleted.currentCityEntity;
                final ForecastParams forecastParams = ForecastParams(
                    currentCityEntity.coord!.lat!,
                    currentCityEntity.coord!.lon!);
                BlocProvider.of<HomeBloc>(context)
                    .add(LoadFwEvent(forecastParams));

                final sunrise = DateConverter.changeDtToDateTimeHour(
                    currentCityEntity.sys!.sunrise, currentCityEntity.timezone);
                final sunset = DateConverter.changeDtToDateTimeHour(
                    currentCityEntity.sys!.sunset, currentCityEntity.timezone);

                return Expanded(
                  child: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.02),
                        child: SizedBox(
                          width: size.width,
                          height: 450,
                          child: PageView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            allowImplicitScrolling: true,
                            controller: _pageController,
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 50),
                                      child: Text(
                                        currentCityEntity.name!,
                                        style: const TextStyle(
                                            fontSize: 30, color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Text(
                                        currentCityEntity
                                            .weather![0].description!,
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.grey),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: AppBackground.setIconForMain(
                                            currentCityEntity
                                                .weather![0].description!)),

                                    /// Main Temperature
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Text(
                                        "${currentCityEntity.main!
                                            .temp!
                                            .round()
                                            .toString()}\u00B0",
                                        style: const TextStyle(
                                            fontSize: 50, color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),

                                    /// Min and Max Temperature
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            const Text(
                                              'max',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              "${currentCityEntity.main!
                                                  .tempMax!.round()}\u00B0",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10, left: 10),
                                          child: Container(
                                            color: Colors.grey,
                                            width: 2,
                                            height: 40,
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            const Text(
                                              'min',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              "${currentCityEntity.main!
                                                  .tempMin!.round()}\u00B0",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              } else {
                                return Container(
                                  color: Colors.amber,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      /// Page indicator
                      Center(
                        child: SmoothPageIndicator(
                          controller: _pageController,
                          count: 2,
                          effect: const ExpandingDotsEffect(
                            dotHeight: 10,
                            dotWidth: 10,
                            spacing: 5,
                            activeDotColor: Colors.white,
                          ),
                          onDotClicked: (index) {
                            _pageController.animateToPage(index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn);
                          },
                        ),
                      ),

                      const Divider(
                        color: Colors.white,
                      ),

                      /// ForeCast 7 Days

                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: SizedBox(
                          width: double.infinity,
                          height: 110,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Center(
                              child: BlocBuilder<HomeBloc, HomeState>(
                                builder: (context, state) {
                                  if (state.fwStatus is FwLoading) {
                                    return const DotLoadingWidget();
                                  }
                                  if (state.fwStatus is FwCompleted) {
                                    final FwCompleted fwCompleted =
                                    state.fwStatus as FwCompleted;
                                    final ForecastDaysEntity entity =
                                        fwCompleted.forecastDaysEntity;
                                    final List<DataList> dataList = entity.list!;

                                    return ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 8,
                                      itemBuilder: (context, index) {
                                        return DaysWeatherView(
                                          daily: dataList[index]
                                        );
                                      },
                                    );
                                  }
                                  return const Text(
                                    'Error',
                                    style: TextStyle(color: Colors.white),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: size.width,
                        height: 1,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 30,
                      ),

                      /// Wind Speed Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Wind Speed',
                                style: TextStyle(
                                    fontSize: size.height * 0.017,
                                    color: Colors.amber),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  '${currentCityEntity.wind!.speed!} m/s',
                                  style: TextStyle(
                                      fontSize: size.height * 0.016,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 2,
                            height: 50,
                            color: Colors.white.withOpacity(0.4),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              Text(
                                'Sunrise',
                                style: TextStyle(
                                    fontSize: size.height * 0.017,
                                    color: Colors.amber),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  sunrise,
                                  style: TextStyle(
                                      fontSize: size.height * 0.016,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 2,
                            height: 50,
                            color: Colors.white.withOpacity(0.4),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              Text(
                                'Sunset',
                                style: TextStyle(
                                    fontSize: size.height * 0.017,
                                    color: Colors.amber),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  sunset,
                                  style: TextStyle(
                                      fontSize: size.height * 0.016,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 2,
                            height: 50,
                            color: Colors.white.withOpacity(0.4),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              Text(
                                'Humidity',
                                style: TextStyle(
                                    fontSize: size.height * 0.017,
                                    color: Colors.amber),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  '${currentCityEntity.main!.humidity!}%',
                                  style: TextStyle(
                                      fontSize: size.height * 0.016,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                );
              }

              /// Error State
              if (state.cwStatus is CwError) {
                return const Center(
                  child: Text(
                    'Error',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
