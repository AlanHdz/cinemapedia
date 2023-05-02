import 'package:cinemapedia/presentation/providers/movies/initial_loading_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_slideshow_provider.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_horizontal_listview.dart';
import 'package:cinemapedia/presentation/widgets/movies/movies_slideshow.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_bottom_navigation.dart';
import 'package:cinemapedia/presentation/widgets/shared/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_appbar.dart';

class HomeScreen extends StatelessWidget {
  static String name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {

  @override
  void initState() {
    super.initState();

    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {

    final initialLoading = ref.watch(initialLoadingProvider);
    if (initialLoading) return FullScreenLoader();

    final slideShowMovies = ref.watch(movieSlideshowProvider);
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);

    return CustomScrollView(
      slivers: [

        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: CustomAppBar(),
          ),
        ),

        SliverList(delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Column(
              children: [
                //const CustomAppBar(),
                MoviesSlideshow(movies: slideShowMovies),
                MovieHorizontalListView(movies: nowPlayingMovies,
                  title: 'En cines', 
                  subTitle: 'Lunes 20', 
                  loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage() 
                ),
                MovieHorizontalListView(movies: popularMovies,
                  title: 'Populares', 
                  //subTitle: 'En este mes', 
                  loadNextPage: () => ref.read(popularMoviesProvider.notifier).loadNextPage() 
                ),
                MovieHorizontalListView(movies: upcomingMovies,
                  title: 'Proximamente', 
                  subTitle: 'Desde siempre', 
                  loadNextPage: () => ref.read(upcomingMoviesProvider.notifier).loadNextPage() 
                ),
                MovieHorizontalListView(movies: topRatedMovies,
                  title: 'Mejor calificadas', 
                  subTitle: 'Desde siempre', 
                  loadNextPage: () => ref.read(topRatedMoviesProvider.notifier).loadNextPage() 
                ),
                const SizedBox(height: 50,)
              ],
            );
          },
          childCount: 1
        )),
      ]
    );
  }
}