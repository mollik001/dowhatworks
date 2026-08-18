import 'package:dowhatworks/app/modules/home/controllers/home_controller.dart';
import 'package:dowhatworks/app/modules/home/widgets/custom_navbar.dart';
import 'package:dowhatworks/app/modules/home/views/home_view.dart';
import 'package:dowhatworks/app/modules/daniel/controllers/daniel_controller.dart';
import 'package:dowhatworks/app/modules/daniel/views/daniel_view.dart';
import 'package:dowhatworks/app/modules/lab/controllers/lab_controller.dart';
import 'package:dowhatworks/app/modules/lab/views/lab_view.dart';
import 'package:dowhatworks/app/modules/results/controllers/results_controller.dart';
import 'package:dowhatworks/app/modules/results/views/results_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    if (!Get.isRegistered<HomeController>()) {
      Get.put<HomeController>(HomeController());
    }
    if (!Get.isRegistered<DanielController>()) {
      Get.put<DanielController>(DanielController());
    }
    if (!Get.isRegistered<LabController>()) {
      Get.put<LabController>(LabController());
    }
    if (!Get.isRegistered<ResultsController>()) {
      Get.put<ResultsController>(ResultsController());
    }

    // Keep _selectedIndex in sync with HomeController.selectedTabIndex
    ever(Get.find<HomeController>().selectedTabIndex, (int index) {
      if (mounted) setState(() => _selectedIndex = index);
      if (index == 0) Get.find<HomeController>().fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: _buildTopRightGradient(),
          ),
          SafeArea(
            bottom: false,
            child: IndexedStack(
              index: _selectedIndex,
              children: const [
                HomeView(),
                DanielView(),
                LabView(),
                ResultsView(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemTap: (index) {
          Get.find<HomeController>().switchTab(index);
        },
      ),
    );
  }

  Widget _buildTopRightGradient() {
    return Container(
      width: 200.w,
      height: 200.h,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topRight,
          radius: 1,
          colors: [
            const Color(0xFF1B110D),
            const Color(0xFF1B110D).withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}
