import 'package:dowhatworks/app/modules/home/controllers/home_controller.dart';
import 'package:dowhatworks/app/modules/home/widgets/home_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Do What Works'),
        centerTitle: true,
      ),
      body: const Center(
        child: HomeWidget(),
      ),
    );
  }
}
