import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes/theme_provider.dart';
import 'trendingmoviesday/trending_movies_day.dart';
import 'ui_infor_user.dart';
import 'foryou/foryou_screen.dart';
import 'upcoming/upcoming_screen.dart';
import 'nowplay/nowplay_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lấy thông tin về chế độ tối từ provider
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    // Tùy chỉnh màu sắc cho TabBar dựa trên chế độ tối
    Color selectedColor = isDarkMode ? Colors.white : Colors.black;
    Color unselectedColor = isDarkMode ? Colors.white60 : Colors.black54;
    Color indicatorColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50),
          const UIInforUser(),
          TabBar(
            controller: _tabController,
            labelColor: selectedColor,
            unselectedLabelColor: unselectedColor,
            indicatorColor: indicatorColor,
            tabs: const [
              Tab(text: 'For You'),
              Tab(text: 'Trending'),
              Tab(text: 'Coming'),
              Tab(text: 'Now PLay'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                ForYouScreen(),
                TrendingMoviesDay(),
                UpComingScreen(),
                NowPlayScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
